#=require bootstrap

LOOKUP_FAIL_MSG = "Sorry, can't get the word at this moment"
LOOKUP_MSG = "Trying hard to look up the word now"

app = angular.module 'LearnByRead', ['ngAnimate']

app.config ($httpProvider) ->
	$httpProvider.defaults.headers.post['x-csrf-token']= $('#csrf').val()

app.controller 'RootCtrl', ($scope, $timeout) ->
	$scope.hideMessage = true
	$scope.$on 'wordaddedToBoard', (e, args) ->
		$scope.message = content: args.message, status: args.result
		$scope.hideMessage = false
		$timeout -> 
			$scope.hideMessage = true
		, 3000

app.controller 'PageCtrl', ($scope, $http) ->
	getPage = (pageNum)->
		$http.get("/page/#{$scope.book}/#{pageNum}").success (data) ->
			$scope.page = data
			$scope.pageNum = data.index
	$scope.init = (book, pageNum, totalPageNum) ->
		$scope.book = book
		$scope.totalPageNum = totalPageNum
		getPage(pageNum)
	$scope.lookupWord = (args, $event) ->
		$scope.$broadcast 'lookupWord', 
			word: args.word
			sentence: $scope.page.sentences[args.index]
			el: $event.target
	$scope.previous = ->
		getPage($scope.pageNum - 1) if $scope.pageNum > 1
	$scope.next = ->
		getPage($scope.pageNum + 1) if $scope.pageNum < $scope.totalPageNum

app.controller 'WordCtrl', ($scope, $http) ->
	$scope.$on 'lookupWord', (e, args) ->
		$scope.status = "looking"
		$scope.word = null
		$scope.sentence = LOOKUP_MSG
		$scope.entries = null
		$http.get("/lookup?word=#{args.word}").success (data) ->
			if data.error
				$scope.status = "error"
				return $scope.sentence = LOOKUP_FAIL_MSG
			$scope.status = "success"
			$scope.word = data.word
			$scope.sentence = args.sentence
			$scope.entries = data.entries
	$scope.pickSense = (sense, speech, $event) ->
		if sense.origin?
			$scope.word = sense.origin.word
			$scope.entries = sense.origin.entries
			$event.stopPropagation()
		else
			$http.post("/board/add", 
				word: $scope.word
				sentence: $scope.sentence
				speech: speech
				sense: sense).success((data) ->
					$scope.$emit 'wordaddedToBoard', data
				).error (data) ->
					$scope.$emit 'wordaddedToBoard', result:"error"

app.directive 'pageContent', ($compile) ->
	link: ($scope, el, attrs) ->
		$scope.$watch 'page', (newVal) ->
			el.html ""
			if newVal?.title?
				el.append "<h1>" + newVal.title.replace?(/\b(\w+?)\b/g, "<span ng-click=\"lookupWord({word:'$1',index:#{i}}, $event)\">$1</span>") + "</h1>"
			if newVal?.sentences?
				for sentence, i in newVal.sentences
					el.append "<br/><br/>" if sentence is ""
					el.append sentence.replace?(/\b(\w+?)\b/g, "<span ng-click=\"lookupWord({word:'$1',index:#{i}}, $event)\">$1</span>") + " "

			$compile(el.contents()) $scope
		$scope.$on 'lookupWord', (e, args) ->
			$(args.el).addClass 'label label-primary'

app.directive 'wordDialog', ->
	templateUrl: '/partials/word-dlg'
	link: ($scope, el, attrs) ->
		$scope.$on 'lookupWord', (e, args) ->
			el.modal 'show'
		$scope.hide = () ->
			el.modal 'hide'
			return
		el.modal show:false
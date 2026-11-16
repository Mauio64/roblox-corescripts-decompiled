return function(p, _)
	return {
		screen = p.ChatAppReducer.ExternalNavigationRequest.screen,
		params = p.ChatAppReducer.ExternalNavigationRequest.params,
		requestId = p.ChatAppReducer.ExternalNavigationRequest.requestId,
		completedRequestId = p.ChatAppReducer.ExternalNavigationRequest.completedRequestId
	}
end

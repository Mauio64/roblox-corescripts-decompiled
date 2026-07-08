return {
	NetworkStatus = {
		loading = 1,
		setVariables = 2,
		fetchMore = 3,
		refetch = 4,
		poll = 6,
		ready = 7,
		error = 8
	},
	isNetworkRequestInFlight = function(n1: number?) -- line: 65
		if n1 then
			return n1 < 7
		end

		return false
	end
}

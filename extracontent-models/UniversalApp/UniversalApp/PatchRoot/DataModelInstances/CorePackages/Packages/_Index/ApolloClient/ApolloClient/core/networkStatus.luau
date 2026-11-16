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
	isNetworkRequestInFlight = function(p: number?): boolean
		if p then
			return p < 7
		end

		return false
	end
}

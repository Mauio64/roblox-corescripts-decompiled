local HttpService = game:GetService("HttpService")

return {
	_sessionId = "",
	Get = function(p2)
		if p2._sessionId == "" then
			p2._sessionId = HttpService:GenerateGUID(false)
		end

		return p2._sessionId
	end,
	Refresh = function(self)
		self._sessionId = HttpService:GenerateGUID(false)
		return self._sessionId
	end
}

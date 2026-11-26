local now = nil

return {
	connect = function(p2)
		local onHideConnection = p2.OnHide:Connect(function()
			now = os.clock()
		end)
		return function()
			onHideConnection:Disconnect()
		end
	end,
	getLastHiddenAt = function()
		return now
	end
}

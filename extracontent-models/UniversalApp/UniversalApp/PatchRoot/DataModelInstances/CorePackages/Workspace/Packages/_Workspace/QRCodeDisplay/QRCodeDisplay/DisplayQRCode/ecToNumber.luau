local QRCodeDisplay = script:FindFirstAncestor("QRCodeDisplay")

require(QRCodeDisplay.Common.ECLevels)

return function(p1) -- line: 4
	return (tonumber(p1))
end

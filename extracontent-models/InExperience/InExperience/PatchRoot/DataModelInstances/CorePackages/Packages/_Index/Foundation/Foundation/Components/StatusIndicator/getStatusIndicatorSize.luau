local Foundation = script:FindFirstAncestor("Foundation")

local StatusIndicatorSize = require(Foundation.Enums.StatusIndicatorSize)

require(Foundation.Providers.Style.Tokens)

local function getStatusIndicatorSize(p, p2, flag: boolean)
	if p2 == StatusIndicatorSize.Large or p2 == StatusIndicatorSize.Pictogram then
		return p.Size.Size_500
	end

	if flag then
		return p.Size.Size_400
	end

	if p2 == StatusIndicatorSize.Medium then
		return p.Size.Size_250
	end

	if p2 == StatusIndicatorSize.Small then
		return p.Size.Size_200
	end

	return p.Size.Size_150
end

return getStatusIndicatorSize

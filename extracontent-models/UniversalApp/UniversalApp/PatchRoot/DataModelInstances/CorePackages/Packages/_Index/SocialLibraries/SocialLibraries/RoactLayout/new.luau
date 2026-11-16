local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact

local function new(blockLayout, options)
	local children = { blockLayout = blockLayout }

	for i, v in ipairs(options or {}) do
		local size = v.size
		local element = v.element

		children[i .. "-block"] = roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = size, LayoutOrder = i },
			{ child = element }
		)
	end

	return children
end

return new

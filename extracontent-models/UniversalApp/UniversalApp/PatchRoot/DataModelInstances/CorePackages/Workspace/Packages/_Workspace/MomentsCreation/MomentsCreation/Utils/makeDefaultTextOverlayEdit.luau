local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local Constants = require(MomentsCreation.Constants)

require(MomentsCreation.Parent.MomentsTypes)

local function makeDefaultTextOverlayEdit() -- line: 23
	-- upvalues: Constants (copy)
	return {
		rotation = 0,
		scale = 1,
		text = "",
		zIndex = 1,
		position = UDim2.fromScale(0.5, 0.5),
		textOverlayStyle = {
			font = Enum.Font.BuilderSansMedium,
			fontColor = Color3.new(0, 0, 0),
			fontSize = Constants.TextOverlay.DefaultFontSize,
			textXAlignment = Enum.TextXAlignment.Center
		}
	}
end

return makeDefaultTextOverlayEdit

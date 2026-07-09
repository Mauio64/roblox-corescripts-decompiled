local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local SocialLibraries = require(AppChat.SocialLibraries)
local Roact = require(AppChatParent.Roact)
local UIBlox = require(AppChatParent.UIBlox)
local InputBoxWithCharacterCounter = SocialLibraries.Components.InputBoxWithCharacterCounter
local v7 = Roact.PureComponent:extend("ChatNameInputBox")

v7.defaultProps = {
	initialInputText = "",
	placeholderText = "(PLACEHOLDER) Name your chat group"
}

function v7.render(p1) -- line: 18
	-- upvalues: UIBlox (copy), Roact (copy), InputBoxWithCharacterCounter (copy)
	return UIBlox.Style.withStyle(function(p2) -- line: 19
		-- upvalues: Roact (copy), InputBoxWithCharacterCounter (copy), p1 (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 64)
		}, {
			InputBox = Roact.createElement(InputBoxWithCharacterCounter, {
				validInputTextTransparency = 0,
				invalidInputTextTransparency = 0,
				inputTextSize = 23,
				inputTextTransparency = 0,
				placeholderTextTransparency = 0,
				clearIcon = "rbxasset://textures/ui/LuaChat/icons/ic-clear-solid.png",
				characterLimit = 150,
				initialInputText = p1.props.initialInputText,
				validInputTextColor3 = Color3.fromRGB(117, 117, 117),
				invalidInputTextColor3 = Color3.fromRGB(226, 35, 26),
				inputTextFont = Enum.Font.Gotham,
				inputTextColor3 = Color3.fromRGB(25, 25, 25),
				placeholderTextColor3 = Color3.fromRGB(184, 184, 184),
				placeholderText = p1.props.placeholderText,
				clearIconColor3 = Color3.fromRGB(255, 255, 255),
				style = p2
			})
		})
	end)
end

return v7

local ParentParent = script.Parent.Parent.Parent.Parent
local AppCommonLib = require(ParentParent.AppCommonLib)
local React = require(ParentParent.React)
local UIBlox = require(ParentParent.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local AppCommonLibText = AppCommonLib.Text
local useStyle = UIBlox.Core.Style.useStyle

return function(t1: {[any]: any}) -- line: 25
	-- upvalues: useStyle (copy), React (copy), AppCommonLibText (copy), Button (copy), ButtonType (copy)
	local v10 = useStyle()
	local Header2Font = v10.Font.Header2.Font
	local v12 = v10.Font.BaseSize * v10.Font.Header2.RelativeSize
	local v13 = React.useMemo(function() -- line: 31
		-- upvalues: t1 (copy), AppCommonLibText (copy), Header2Font (copy), v12 (copy)
		if t1.buttonWidth then
			return t1.buttonWidth
		end

		return AppCommonLibText.GetTextWidth(t1.text, Header2Font, v12) + 24
	end, {
		t1.text,
		Header2Font,
		v12,
		t1.buttonWidth
	})
	local v14 = if not t1.buttonHeight then UDim2.new(0, v13, 1, 0) else UDim2.fromOffset(v13, t1.buttonHeight)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = t1.AnchorPoint,
		LayoutOrder = t1.LayoutOrder,
		Position = t1.Position,
		Size = v14
	}, {
		ShowMoreButton = React.createElement(Button, {
			buttonType = ButtonType.Secondary,
			onActivated = t1.onActivated,
			size = UDim2.fromScale(1, 1),
			text = t1.text
		})
	})
end

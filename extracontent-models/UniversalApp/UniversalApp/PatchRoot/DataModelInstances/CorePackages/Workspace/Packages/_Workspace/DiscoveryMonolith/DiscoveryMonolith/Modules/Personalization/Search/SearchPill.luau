local TextService = game:GetService("TextService")
local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local ImpressionsTagUtility = require(Parent.Impressions).ImpressionsTagUtility
local React = require(Parent.React)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useDesignTokens = require(Parent.Style).useDesignTokens

function SearchPill(t1: {[any]: any}) -- line: 31
	-- upvalues: useDesignTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), React (copy), TextService (copy), ImpressionsTagUtility (copy)
	local v8 = useDesignTokens()
	local v9 = t1.font or if not FFlagRenameDeprecatedUIBloxTokens then v8.Semantic.Typography.Body.Font else v8.Typography.BodyLarge.Font
	local v10 = t1.textColor or ((if not FFlagRenameDeprecatedUIBloxTokens then v8.Semantic.Color.Text.Emphasis else v8.Color.Content.Emphasis)).Color3
	local textSize = t1.textSize
	local v12 = React.useMemo(function() -- line: 46
		-- upvalues: TextService (copy), t1 (copy), textSize (copy), v9 (copy)
		return TextService:GetTextSize(t1.text, textSize, v9, Vector2.new(1e999, textSize))
	end, {
		t1.text,
		textSize,
		v9
	})
	local v13 = React.useRef(nil)

	React.useEffect(function() -- line: 51
		-- upvalues: t1 (copy), ImpressionsTagUtility (copy), v13 (copy)
		local impressionsTag = t1.impressionsTag
		local index = t1.index

		if t1.impressionsTag and index then
			ImpressionsTagUtility.AddTag(v13, impressionsTag, index)
		end

		return function() -- line: 58
			-- upvalues: t1 (copy), index (copy), ImpressionsTagUtility (copy), v13 (copy), impressionsTag (copy)
			if t1.impressionsTag and index then
				ImpressionsTagUtility.RemoveTag(v13, impressionsTag, index)
			end
		end
	end, {
		t1.impressionsTag,
		t1.index
	})

	return React.createElement("TextButton", {
		LayoutOrder = t1.layoutOrder or 1,
		Size = UDim2.new(0, v12.X + t1.horizontalPadding * 2, 0, textSize + t1.verticalPadding * 2),
		BackgroundColor3 = t1.backgroundColor,
		BackgroundTransparency = t1.backgroundTransparency,
		BorderSizePixel = 0,
		TextTransparency = 1,
		Text = "",
		Selectable = true,
		[React.Event.Activated] = t1.onActivated,
		ref = v13
	}, {
		PillText = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(v12.X, v12.Y),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Font = v9,
			Text = t1.text,
			TextSize = textSize,
			TextColor3 = v10
		}),
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.5, 0)
		})
	})
end

return SearchPill

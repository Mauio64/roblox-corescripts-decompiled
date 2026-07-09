local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local FFlagRenameDeprecatedUIBloxTokens = require(BulkPurchaseAppParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useDesignTokens = require(BulkPurchaseAppParent.Style).useDesignTokens
local useScreenSize = require(BulkPurchaseAppParent.EconomyCommonCoreScriptHooks).useScreenSize
local constants = require(BulkPurchaseApp.constants)

local function FullPagePromptTwoPanelLayout(t1: {[any]: any}) -- line: 18
	-- upvalues: React (copy), useScreenSize (copy), useDesignTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), constants (copy)
	local v10, v11 = React.useBinding(Vector2.new(0, 0))
	local v12 = useScreenSize()
	local v13 = useDesignTokens()
	local v14 = if not FFlagRenameDeprecatedUIBloxTokens then v13.Global.Space_150 else v13.Size.Size_300
	local v15 = v12.X < constants.MOBILE_BREAKPOINT and v12.X < v12.Y

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = t1.size,
		LayoutOrder = t1.LayoutOrder
	}, {
		StartSlot = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = v10:map(function(vector2: Vector2) -- line: 34
				-- upvalues: v15 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), v13 (copy), v14 (copy)
				if v15 then
					return (UDim2.new(1, 0, 1, -(vector2.Y + if not FFlagRenameDeprecatedUIBloxTokens then v13.Global.Space_300 else v13.Size.Size_600)))
				end

				return (UDim2.new(0.5, -v14, 1, 0))
			end)
		}, t1.startSlot),
		EndSlot = React.createElement("Frame", {
			Size = if not v15 then UDim2.new(0.5, -v14, 0, 0) else UDim2.new(1, 0, 0, 0),
			Position = if not v15 then UDim2.new(0.5, v14, 0, 0) else UDim2.new(0, 0, 1, 0),
			AnchorPoint = if not v15 then Vector2.new(0, 0) else Vector2.new(0, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			[React.Change.AbsoluteSize] = function(p1) -- line: 61
				-- upvalues: v11 (copy)
				v11(p1.AbsoluteSize)
			end
		}, t1.endSlot)
	})
end

return FullPagePromptTwoPanelLayout

local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useDesignTokens = require(BulkPurchaseAppParent.Style).useDesignTokens
local useScreenSize = require(BulkPurchaseAppParent.EconomyCommonCoreScriptHooks).useScreenSize
local constants = require(BulkPurchaseApp.constants)

local function FullPagePromptTwoPanelLayout(t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy), useScreenSize (copy), useDesignTokens (copy), constants (copy)
	local v9, v10 = React.useBinding(Vector2.new(0, 0))
	local v11 = useScreenSize()
	local v12 = useDesignTokens()
	local Size_300 = v12.Size.Size_300
	local v14 = v11.X < constants.MOBILE_BREAKPOINT and v11.X < v11.Y

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = t1.size,
		LayoutOrder = t1.LayoutOrder
	}, {
		StartSlot = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = v9:map(function(vector2: Vector2) -- line: 30
				-- upvalues: v14 (copy), v12 (copy), Size_300 (copy)
				if v14 then
					return (UDim2.new(1, 0, 1, -(vector2.Y + v12.Size.Size_600)))
				end

				return (UDim2.new(0.5, -Size_300, 1, 0))
			end)
		}, t1.startSlot),
		EndSlot = React.createElement("Frame", {
			Size = if not v14 then UDim2.new(0.5, -Size_300, 0, 0) else UDim2.new(1, 0, 0, 0),
			Position = if not v14 then UDim2.new(0.5, Size_300, 0, 0) else UDim2.new(0, 0, 1, 0),
			AnchorPoint = if not v14 then Vector2.new(0, 0) else Vector2.new(0, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			[React.Change.AbsoluteSize] = function(p1) -- line: 45
				-- upvalues: v10 (copy)
				v10(p1.AbsoluteSize)
			end
		}, t1.endSlot)
	})
end

return FullPagePromptTwoPanelLayout

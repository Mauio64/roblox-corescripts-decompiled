local _select = select

local function v72(tbl, idx, ...)
	local va = { ... }

	for i = 1, _select("#", ...) do
		tbl[idx + i - 1] = va[i]
	end
end

local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local UIBlox = require(ParentParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Interactable = UIBlox.Core.Control.Interactable
local RobloxTranslator = require(ParentParent.RobloxTranslator)
local v8 = RobloxTranslator:FormatByKey("CoreScripts.Ads.Label.WhyThisAd")
local v9 = RobloxTranslator:FormatByKey("CoreScripts.Ads.Label.ReportAd")
local v10 = Images["icons/actions/info"]
local v11 = Images["icons/actions/feedback"]
local v12 = require(script.Parent.Flags).GetAdGuiInteractivityPixelsPerStud() / 50

local function applyScalingUDim(uDim: UDim) -- line: 20
	-- upvalues: v12 (copy)
	return UDim.new(uDim.Scale, uDim.Offset * v12)
end
local function applyScalingUDim2(uDim2: UDim2) -- line: 24
	-- upvalues: v12 (copy)
	return UDim2.new(uDim2.X.Scale, uDim2.X.Offset * v12, uDim2.Y.Scale, uDim2.Y.Offset * v12)
end
local function applyScalingNumber(n1: number) -- line: 28
	-- upvalues: v12 (copy)
	return n1 * v12
end
local function WhyThisAdRow(t1: {[any]: any}) -- line: 41
	-- upvalues: Roact (copy), Interactable (copy), v12 (copy), ImageSetLabel (copy), v10 (copy), v8 (copy)
	local createElement = Roact.createElement
	local v23 = Interactable
	local t2 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		[Roact.Event.Activated] = t1.onWhyThisAdActivated,
		onStateChanged = function() -- line: 46
		end
	}
	local t3 = {}
	local createElement2 = Roact.createElement
	local t4 = {}
	local uDim = UDim.new(0, 10)

	t4.CornerRadius = UDim.new(uDim.Scale, uDim.Offset * v12)
	t3.UICorner = createElement2("UICorner", t4)

	local createElement3 = Roact.createElement
	local t5 = {}
	local uDim2 = UDim.new(0, 16)

	t5.PaddingTop = UDim.new(uDim2.Scale, uDim2.Offset * v12)

	local uDim3 = UDim.new(0, 8)

	t5.PaddingBottom = UDim.new(uDim3.Scale, uDim3.Offset * v12)

	local uDim4 = UDim.new(0, 16)

	t5.PaddingLeft = UDim.new(uDim4.Scale, uDim4.Offset * v12)

	local uDim5 = UDim.new(0, 48)

	t5.PaddingRight = UDim.new(uDim5.Scale, uDim5.Offset * v12)
	t3.UIPadding = createElement3("UIPadding", t5)

	local createElement4 = Roact.createElement
	local t6 = {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center
	}
	local uDim6 = UDim.new(0, 16)

	t6.Padding = UDim.new(uDim6.Scale, uDim6.Offset * v12)
	t3.UIListLayout = createElement4("UIListLayout", t6)

	local createElement5 = Roact.createElement
	local v39 = ImageSetLabel
	local t7 = {
		BackgroundTransparency = 1,
		Image = v10
	}
	local uDim2_2 = UDim2.fromOffset(24, 24)

	t7.Size = UDim2.new(uDim2_2.X.Scale, uDim2_2.X.Offset * v12, uDim2_2.Y.Scale, uDim2_2.Y.Offset * v12)
	t3.Icon = createElement5(v39, t7)
	t3.TextLabel = Roact.createElement("TextLabel", {
		BackgroundTransparency = 1,
		TextScaled = false,
		TextWrapped = true,
		Text = v8,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.GothamMedium,
		TextSize = 24 * v12,
		AutomaticSize = Enum.AutomaticSize.XY
	})

	return createElement(v23, t2, t3)
end
local function ReportAdRow(t8: {[any]: any}) -- line: 81
	-- upvalues: Roact (copy), Interactable (copy), v12 (copy), ImageSetLabel (copy), v11 (copy), v9 (copy)
	local createElement = Roact.createElement
	local v44 = Interactable
	local t9 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		[Roact.Event.Activated] = t8.onReportAdActivated,
		onStateChanged = function() -- line: 86
		end
	}
	local t10 = {}
	local createElement6 = Roact.createElement
	local t11 = {}
	local uDim = UDim.new(0, 10)

	t11.CornerRadius = UDim.new(uDim.Scale, uDim.Offset * v12)
	t10.UICorner = createElement6("UICorner", t11)

	local createElement7 = Roact.createElement
	local t12 = {}
	local uDim7 = UDim.new(0, 8)

	t12.PaddingTop = UDim.new(uDim7.Scale, uDim7.Offset * v12)

	local uDim8 = UDim.new(0, 16)

	t12.PaddingBottom = UDim.new(uDim8.Scale, uDim8.Offset * v12)

	local uDim9 = UDim.new(0, 16)

	t12.PaddingLeft = UDim.new(uDim9.Scale, uDim9.Offset * v12)

	local uDim10 = UDim.new(0, 48)

	t12.PaddingRight = UDim.new(uDim10.Scale, uDim10.Offset * v12)
	t10.UIPadding = createElement7("UIPadding", t12)

	local createElement8 = Roact.createElement
	local t13 = {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center
	}
	local uDim11 = UDim.new(0, 16)

	t13.Padding = UDim.new(uDim11.Scale, uDim11.Offset * v12)
	t10.UIListLayout = createElement8("UIListLayout", t13)

	local createElement9 = Roact.createElement
	local v60 = ImageSetLabel
	local t14 = {
		BackgroundTransparency = 1,
		Image = v11
	}
	local uDim2 = UDim2.fromOffset(24, 24)

	t14.Size = UDim2.new(uDim2.X.Scale, uDim2.X.Offset * v12, uDim2.Y.Scale, uDim2.Y.Offset * v12)
	t10.Icon = createElement9(v60, t14)
	t10.TextLabel = Roact.createElement("TextLabel", {
		BackgroundTransparency = 1,
		TextScaled = false,
		TextWrapped = true,
		Text = v9,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.GothamMedium,
		TextSize = 24 * v12,
		AutomaticSize = Enum.AutomaticSize.XY
	})

	return createElement(v44, t9, t10)
end

function AdDropdownMenu(t15: {[any]: any}) -- line: 121
	-- upvalues: Roact (copy), v12 (copy), WhyThisAdRow (copy), ReportAdRow (copy)
	local createElement = Roact.createElement
	local t16 = {
		Visible = t15.showDropDownMenu,
		Position = t15.Position or UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = t15.transparency,
		AnchorPoint = t15.AnchorPoint or Vector2.new(0.5, 0.5)
	}
	local uDim2 = UDim2.new(0.24, 0, 0.12, 0)

	t16.Size = UDim2.new(uDim2.X.Scale, uDim2.X.Offset * v12, uDim2.Y.Scale, uDim2.Y.Offset * v12)
	t16.AutomaticSize = Enum.AutomaticSize.XY

	local t17 = {}
	local createElement10 = Roact.createElement
	local t18 = {}
	local uDim = UDim.new(0, 10)

	t18.CornerRadius = UDim.new(uDim.Scale, uDim.Offset * v12)
	t17.UICorner = createElement10("UICorner", t18)
	t17.UIListLayout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center
	})

	local v71 = WhyThisAdRow(t15)

	t17[1] = v71
	v72(t17, 2, ReportAdRow(t15))

	return createElement("Frame", t16, t17)
end

return AdDropdownMenu

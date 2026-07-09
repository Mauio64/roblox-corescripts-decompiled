local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Modules = CoreGui.RobloxGui.Modules
local IconTextBox = require(Modules.AvatarExperience.Catalog.Components.IconTextBox)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local GetFFlagL2ControllerSupport = require(Modules.AvatarExperience.Flags.GetFFlagL2ControllerSupport)
local Focusable = RoactGamepad.Focusable
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local v13 = Images["icons/common/robux"]

local function shouldShowMinimumAmountMessage(s1: string, n1: number) -- line: 25
	if s1 then
		local num = tonumber(s1)

		return not num or num <= (n1 or 0)
	end

	return true
end

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 45
	-- upvalues: useLocalization (copy), useStyle (copy), React (copy), Focusable (copy), IconTextBox (copy), v13 (copy), GetFFlagL2ControllerSupport (copy)
	local v20 = useLocalization({
		setPriceLabel = "Feature.Catalog.Heading.SetPrice",
		pricePlaceholderText = "Feature.Catalog.Label.Price",
		minAmountText = "Feature.Catalog.Label.MinimumAmount",
		minAmountTextWithPrice = "Feature.Catalog.Label.MinimumAmountCustom"
	})
	local v21 = useStyle()
	local Theme = v21.Theme
	local Font = v21.Font
	local SubHeader1 = Font.SubHeader1
	local CaptionBody = Font.CaptionBody
	local RelativeSize = SubHeader1.RelativeSize
	local RelativeSize2 = CaptionBody.RelativeSize
	local BaseSize = Font.BaseSize
	local v29 = RelativeSize * BaseSize
	local v30 = RelativeSize2 * BaseSize
	local minAmountText = v20.minAmountText

	if t1.priceFloor and t1.priceFloor > 0 then
		minAmountText = v20.minAmountTextWithPrice:gsub("{minimumAmount}", (tostring(t1.priceFloor)))
	end

	local createElement = React.createElement
	local t2 = {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0)
	}
	local t3 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 10)
		}),
		SetPriceSubHeader = React.createElement("TextLabel", {
			LayoutOrder = 1,
			TextWrapped = true,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = v20.setPriceLabel,
			Font = SubHeader1.Font,
			Size = UDim2.fromScale(1, 0),
			TextSize = v29,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Theme.TextEmphasis.Color,
			TextTransparency = Theme.TextEmphasis.Transparency
		}),
		PriceInputBox = React.createElement(Focusable[IconTextBox], {
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			PlaceholderText = v20.pricePlaceholderText,
			Image = v13,
			TextInputType = Enum.TextInputType.Number,
			ref = if not GetFFlagL2ControllerSupport() then nil else p1,
			NextSelectionUp = if not GetFFlagL2ControllerSupport() then nil else t1.NextSelectionUp,
			NextSelectionDown = if not GetFFlagL2ControllerSupport() then nil else t1.NextSelectionDown,
			NextSelectionLeft = if not GetFFlagL2ControllerSupport() then nil else t1.NextSelectionLeft,
			NextSelectionRight = if not GetFFlagL2ControllerSupport() then nil else t1.NextSelectionRight,
			[React.Change.Text] = function(p2) -- line: 108
				-- upvalues: t1 (copy)
				local p2Text = p2.Text

				if string.len(p2Text) > 10 then
					p2.Text = t1.priceInRobux

					return
				end

				if p2Text == nil or p2Text == "" then
					t1.setPriceInRobux("")

					return
				end

				if string.match(p2Text, "^[0-9]+$") then
					t1.setPriceInRobux(p2Text)

					return
				end

				p2.Text = t1.priceInRobux
			end
		})
	}
	local createElement2 = React.createElement
	local t4 = {
		LayoutOrder = 3,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v30 + 2)
	}
	local t5 = {}
	local priceInRobux = t1.priceInRobux
	local priceFloor = t1.priceFloor
	local v41

	if priceInRobux then
		local num = tonumber(priceInRobux)

		v41 = not num or num <= (priceFloor or 0)
	else
		v41 = true
	end

	if v41 then
		v41 = React.createElement("TextLabel", {
			LayoutOrder = 1,
			TextWrapped = true,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = minAmountText,
			Font = CaptionBody.Font,
			Size = UDim2.fromScale(1, 0),
			TextSize = v30,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = Theme.TextDefault.Color,
			TextTransparency = Theme.TextDefault.Transparency
		})
	end

	t5.MinAmountText = v41
	t3.MinAmountContainer = createElement2("Frame", t4, t5)

	return createElement("Frame", t2, t3)
end))

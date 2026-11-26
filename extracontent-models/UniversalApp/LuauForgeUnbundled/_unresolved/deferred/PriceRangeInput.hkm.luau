local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dFs")

local fFlagMinMaxPriceValidation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagMinMaxPriceValidation

local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)

local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local styledTextLabel = UIBlox.App.Text.StyledTextLabel

local module2 = require("@luauforge/bundled/dPU")
local module3 = require("@luauforge/deferred/hkl")

local function safeUpdateText(p2, text)
	if p2 and p2.current then
		local success, result = pcall(function()
			if p2.current.Text ~= text then
				p2.current.Text = text
			end
		end)

		if not success then
			module("[PriceRangeInput] Failed to update text to " .. text .. " with error " .. tostring(result))
		end
	end
end

local v5 = { minPrice = module2.MinPriceFilter, maxPrice = module2.MaxPriceFilter }

local function PriceRangeInput(p2)
	local joined = Dash.join(v5, p2)

	local v6 = useStyle()
	local font = v6.Font
	local theme = v6.Theme
	local alert = v6.Tokens.Color.System.Alert

	local v7 = useLocalization({
		min = "Feature.Catalog.Label.Filter.PriceMin",
		max = "Feature.Catalog.Label.Filter.PriceMax"
	})

	local udim = UDim.new(0.5, -13)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	if fFlagMinMaxPriceValidation then
		local state, setState = React.useState(true)

		local v8 = React.useCallback(function()
			if
				ref.current
				and ref2.current
				and (tonumber(ref.current.text) or module2.MinPriceFilter) > (tonumber(ref2.current.text) or module2.MaxPriceFilter)
			then
				return setState(false)
			end

			return setState(true)
		end, {})

		local v9 = React.useCallback(function(value)
			if joined.setMinPrice then
				local v10 = tonumber((value:gsub("%D", "")))
				local v11 = v10 or module2.MinPriceFilter
				joined.setMinPrice(v11)

				local v12 = not v10 and "" or tostring(v11)
				local v13 = ref

				if v13 and v13.current then
					local success, result = pcall(function()
						if v13.current.Text ~= v12 then
							v13.current.Text = v12
						end
					end)

					if not success then
						module("[PriceRangeInput] Failed to update text to " .. v12 .. " with error " .. tostring(result))
					end
				end
			end

			v8()
		end, { joined.setMinPrice, v8 })

		local v10 = React.useCallback(function(value)
			if joined.setMaxPrice then
				local v11 = tonumber((value:gsub("%D", "")))
				local v12 = v11 or module2.MaxPriceFilter
				joined.setMaxPrice(v12)

				local v13 = not v11 and "" or tostring(v12)
				local v14 = ref2

				if v14 and v14.current then
					local success, result = pcall(function()
						if v14.current.Text ~= v13 then
							v14.current.Text = v13
						end
					end)

					if not success then
						module("[PriceRangeInput] Failed to update text to " .. v13 .. " with error " .. tostring(result))
					end
				end
			end

			v8()
		end, { joined.setMaxPrice, v8 })

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -12 - v6.Tokens.Size.Size_100 * 2, 0, 30 + v6.Tokens.Size.Size_100 * 2)
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v6.Tokens.Size.Size_100),
				PaddingBottom = UDim.new(0, v6.Tokens.Size.Size_100),
				PaddingLeft = UDim.new(0, v6.Tokens.Size.Size_100),
				PaddingRight = UDim.new(0, v6.Tokens.Size.Size_100)
			}),
			MenuLayoutFrame = React.createElement(
				"Frame",
				{ BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY },
				{
					Padding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, v6.Tokens.Size.Size_100),
						PaddingBottom = UDim.new(0, v6.Tokens.Size.Size_100),
						PaddingLeft = UDim.new(0, v6.Tokens.Size.Size_100),
						PaddingRight = UDim.new(0, v6.Tokens.Size.Size_100)
					}),
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					Corner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, v6.Tokens.Size.Size_100 * 100)
					}),
					Border = React.createElement("UIStroke", {
						Color = alert.Color3,
						Transparency = state and 1 or alert.Transparency,
						Thickness = 2,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					}),
					MinPriceTextBox = React.createElement(module3, {
						text = not (joined.minPrice > module2.MinPriceFilter) and "" or tostring(joined.minPrice),
						placeholderText = v7.min,
						onTextChanged = v9,
						onFocused = joined.onFocused,
						width = udim,
						layoutOrder = 1,
						textBoxRef = ref,
						NextSelectionRight = ref2
					}),
					Dash = React.createElement(styledTextLabel, {
						size = UDim2.fromOffset(26, 30),
						text = "–",
						colorStyle = {
							Color = theme.TextEmphasis.Color,
							Transparency = theme.TextEmphasis.Transparency
						},
						fontStyle = font.Header2,
						textXAlignment = Enum.TextXAlignment.Center,
						layoutOrder = 2
					}),
					MaxPriceTextBox = React.createElement(module3, {
						text = not (joined.maxPrice < module2.MaxPriceFilter) and "" or tostring(joined.maxPrice),
						placeholderText = v7.max,
						onTextChanged = v10,
						onFocused = joined.onFocused,
						width = udim,
						layoutOrder = 3,
						textBoxRef = ref2,
						NextSelectionLeft = ref
					})
				}
			)
		})
	else
		local v8 = React.useCallback(function(value)
			if joined.setMinPrice then
				local v9 = tonumber((value:gsub("%D", "")))
				local v10 = v9 or module2.MinPriceFilter
				joined.setMinPrice(v10)

				local v11 = not v9 and "" or tostring(v10)
				local v12 = ref

				if v12 and v12.current then
					local success, result = pcall(function()
						if v12.current.Text ~= v11 then
							v12.current.Text = v11
						end
					end)

					if not success then
						module("[PriceRangeInput] Failed to update text to " .. v11 .. " with error " .. tostring(result))
					end
				end
			end
		end, { joined.setMinPrice })

		local v9 = React.useCallback(function(value)
			if joined.setMaxPrice then
				local v10 = tonumber((value:gsub("%D", "")))
				local v11 = v10 or module2.MaxPriceFilter
				joined.setMaxPrice(v11)

				local v12 = not v10 and "" or tostring(v11)
				local v13 = ref2

				if v13 and v13.current then
					local success, result = pcall(function()
						if v13.current.Text ~= v12 then
							v13.current.Text = v12
						end
					end)

					if not success then
						module("[PriceRangeInput] Failed to update text to " .. v12 .. " with error " .. tostring(result))
					end
				end
			end
		end, { joined.setMaxPrice })

		return React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -12, 0, 30)
			},
			{
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				MinPriceTextBox = React.createElement(module3, {
					text = not (joined.minPrice > module2.MinPriceFilter) and "" or tostring(joined.minPrice),
					placeholderText = v7.min,
					onTextChanged = v8,
					onFocused = joined.onFocused,
					width = udim,
					layoutOrder = 1,
					textBoxRef = ref,
					NextSelectionRight = ref2
				}),
				Dash = React.createElement(styledTextLabel, {
					size = UDim2.fromOffset(26, 30),
					text = "–",
					colorStyle = {
						Color = theme.TextEmphasis.Color,
						Transparency = theme.TextEmphasis.Transparency
					},
					fontStyle = font.Header2,
					textXAlignment = Enum.TextXAlignment.Center,
					layoutOrder = 2
				}),
				MaxPriceTextBox = React.createElement(module3, {
					text = not (joined.maxPrice < module2.MaxPriceFilter) and "" or tostring(joined.maxPrice),
					placeholderText = v7.max,
					onTextChanged = v9,
					onFocused = joined.onFocused,
					width = udim,
					layoutOrder = 3,
					textBoxRef = ref2,
					NextSelectionLeft = ref
				})
			}
		)
	end
end

return PriceRangeInput

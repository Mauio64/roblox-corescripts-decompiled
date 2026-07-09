local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local mutedError = require(Modules.LuaApp.mutedError)
local FFlagMinMaxPriceValidation = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagMinMaxPriceValidation
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local FilterTextBox = require(script.Parent.FilterTextBox)

local function safeUpdateText(p1, s1: string) -- line: 49
	-- upvalues: mutedError (copy)
	if p1 and p1.current then
		local ok, result = pcall(function() -- line: 51
			-- upvalues: p1 (copy), s1 (copy)
			if p1.current.Text ~= s1 then
				p1.current.Text = s1
			end
		end)

		if not ok then
			mutedError("[PriceRangeInput] Failed to update text to " .. s1 .. " with error " .. tostring(result))
		end
	end
end

local t1 = {
	minPrice = CatalogConstants.MinPriceFilter,
	maxPrice = CatalogConstants.MaxPriceFilter
}

local function PriceRangeInput(t2: {[any]: any}) -- line: 67
	-- upvalues: Dash (copy), t1 (copy), useStyle (copy), useLocalization (copy), React (copy), FFlagMinMaxPriceValidation (copy), CatalogConstants (copy), mutedError (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FilterTextBox (copy), StyledTextLabel (copy)
	local v22 = Dash.join(t1, t2)
	local v23 = useStyle()
	local Font = v23.Font
	local Theme = v23.Theme
	local Common = v23.Tokens.Semantic.Color.Common
	local v27 = useLocalization({
		min = "Feature.Catalog.Label.Filter.PriceMin",
		max = "Feature.Catalog.Label.Filter.PriceMax"
	})
	local uDim = UDim.new(0.5, -13)
	local v29 = React.useRef(nil)
	local v30 = React.useRef(nil)

	if FFlagMinMaxPriceValidation then
		local v31, v32 = React.useState(true)
		local v33 = React.useCallback(function() -- line: 88
			-- upvalues: v29 (copy), v30 (copy), CatalogConstants (copy), v32 (copy)
			if v29.current and (v30.current and (tonumber(v29.current.text) or CatalogConstants.MinPriceFilter) > (tonumber(v30.current.text) or CatalogConstants.MaxPriceFilter)) then
				return v32(false)
			end

			return v32(true)
		end, {})
		local v34 = React.useCallback(function(s2: string) -- line: 99
			-- upvalues: v22 (copy), CatalogConstants (copy), v29 (copy), mutedError (copy), v33 (copy)
			if v22.setMinPrice then
				local num = tonumber((s2:gsub("%D", "")))
				local v40 = num or CatalogConstants.MinPriceFilter

				v22.setMinPrice(v40)

				local v41 = not num and "" or tostring(v40)
				local v42 = v29

				if v42 and v42.current then
					local ok, result = pcall(function() -- line: 51
						-- upvalues: v42 (copy), v41 (copy)
						if v42.current.Text ~= v41 then
							v42.current.Text = v41
						end
					end)

					if not ok then
						mutedError("[PriceRangeInput] Failed to update text to " .. v41 .. " with error " .. tostring(result))
					end
				end
			end

			v33()
		end, {
			v22.setMinPrice,
			v33
		})
		local v35 = React.useCallback(function(s3: string) -- line: 113
			-- upvalues: v22 (copy), CatalogConstants (copy), v30 (copy), mutedError (copy), v33 (copy)
			if v22.setMaxPrice then
				local num = tonumber((s3:gsub("%D", "")))
				local v47 = num or CatalogConstants.MaxPriceFilter

				v22.setMaxPrice(v47)

				local v48 = not num and "" or tostring(v47)
				local v49 = v30

				if v49 and v49.current then
					local ok, result = pcall(function() -- line: 51
						-- upvalues: v49 (copy), v48 (copy)
						if v49.current.Text ~= v48 then
							v49.current.Text = v48
						end
					end)

					if not ok then
						mutedError("[PriceRangeInput] Failed to update text to " .. v48 .. " with error " .. tostring(result))
					end
				end
			end

			v33()
		end, {
			v22.setMaxPrice,
			v33
		})

		return (React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -12 - ((if not FFlagRenameDeprecatedUIBloxTokens then v23.Tokens.Global.Size_50 else v23.Tokens.Size.Size_100)) * 2, 0, 30 + ((if not FFlagRenameDeprecatedUIBloxTokens then v23.Tokens.Global.Size_50 else v23.Tokens.Size.Size_100)) * 2)
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v23.Tokens.Global.Size_50 else v23.Tokens.Size.Size_100),
				PaddingBottom = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v23.Tokens.Global.Size_50 else v23.Tokens.Size.Size_100),
				PaddingLeft = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v23.Tokens.Global.Size_50 else v23.Tokens.Size.Size_100),
				PaddingRight = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v23.Tokens.Global.Size_50 else v23.Tokens.Size.Size_100)
			}),
			MenuLayoutFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v23.Tokens.Global.Size_50 else v23.Tokens.Size.Size_100),
					PaddingBottom = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v23.Tokens.Global.Size_50 else v23.Tokens.Size.Size_100),
					PaddingLeft = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v23.Tokens.Global.Size_50 else v23.Tokens.Size.Size_100),
					PaddingRight = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v23.Tokens.Global.Size_50 else v23.Tokens.Size.Size_100)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				Corner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, ((if not FFlagRenameDeprecatedUIBloxTokens then v23.Tokens.Global.Size_50 else v23.Tokens.Size.Size_100)) * 100)
				}),
				Border = React.createElement("UIStroke", {
					Thickness = 2,
					Color = Common.Alert.Color3,
					Transparency = if not v31 then Common.Alert.Transparency else 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				}),
				MinPriceTextBox = React.createElement(FilterTextBox, {
					layoutOrder = 1,
					text = not (v22.minPrice > CatalogConstants.MinPriceFilter) and "" or tostring(v22.minPrice),
					placeholderText = v27.min,
					onTextChanged = v34,
					onFocused = v22.onFocused,
					width = uDim,
					textBoxRef = v29,
					NextSelectionRight = v30
				}),
				Dash = React.createElement(StyledTextLabel, {
					text = "–",
					layoutOrder = 2,
					size = UDim2.fromOffset(26, 30),
					colorStyle = {
						Color = Theme.TextEmphasis.Color,
						Transparency = Theme.TextEmphasis.Transparency
					},
					fontStyle = Font.Header2,
					textXAlignment = Enum.TextXAlignment.Center
				}),
				MaxPriceTextBox = React.createElement(FilterTextBox, {
					layoutOrder = 3,
					text = not (v22.maxPrice < CatalogConstants.MaxPriceFilter) and "" or tostring(v22.maxPrice),
					placeholderText = v27.max,
					onTextChanged = v35,
					onFocused = v22.onFocused,
					width = uDim,
					textBoxRef = v30,
					NextSelectionLeft = v29
				})
			})
		}))
	end

	local v36 = React.useCallback(function(s4: string) -- line: 277
		-- upvalues: v22 (copy), CatalogConstants (copy), v29 (copy), mutedError (copy)
		if v22.setMinPrice then
			local num = tonumber((s4:gsub("%D", "")))
			local v54 = num or CatalogConstants.MinPriceFilter

			v22.setMinPrice(v54)

			local v55 = not num and "" or tostring(v54)
			local v56 = v29

			if v56 and v56.current then
				local ok, result = pcall(function() -- line: 51
					-- upvalues: v56 (copy), v55 (copy)
					if v56.current.Text ~= v55 then
						v56.current.Text = v55
					end
				end)

				if not ok then
					mutedError("[PriceRangeInput] Failed to update text to " .. v55 .. " with error " .. tostring(result))
				end
			end
		end
	end, { v22.setMinPrice })
	local v37 = React.useCallback(function(s5: string) -- line: 290
		-- upvalues: v22 (copy), CatalogConstants (copy), v30 (copy), mutedError (copy)
		if v22.setMaxPrice then
			local num = tonumber((s5:gsub("%D", "")))
			local v61 = num or CatalogConstants.MaxPriceFilter

			v22.setMaxPrice(v61)

			local v62 = not num and "" or tostring(v61)
			local v63 = v30

			if v63 and v63.current then
				local ok, result = pcall(function() -- line: 51
					-- upvalues: v63 (copy), v62 (copy)
					if v63.current.Text ~= v62 then
						v63.current.Text = v62
					end
				end)

				if not ok then
					mutedError("[PriceRangeInput] Failed to update text to " .. v62 .. " with error " .. tostring(result))
				end
			end
		end
	end, { v22.setMaxPrice })

	return (React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -12, 0, 30)
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		MinPriceTextBox = React.createElement(FilterTextBox, {
			layoutOrder = 1,
			text = not (v22.minPrice > CatalogConstants.MinPriceFilter) and "" or tostring(v22.minPrice),
			placeholderText = v27.min,
			onTextChanged = v36,
			onFocused = v22.onFocused,
			width = uDim,
			textBoxRef = v29,
			NextSelectionRight = v30
		}),
		Dash = React.createElement(StyledTextLabel, {
			text = "–",
			layoutOrder = 2,
			size = UDim2.fromOffset(26, 30),
			colorStyle = {
				Color = Theme.TextEmphasis.Color,
				Transparency = Theme.TextEmphasis.Transparency
			},
			fontStyle = Font.Header2,
			textXAlignment = Enum.TextXAlignment.Center
		}),
		MaxPriceTextBox = React.createElement(FilterTextBox, {
			layoutOrder = 3,
			text = not (v22.maxPrice < CatalogConstants.MaxPriceFilter) and "" or tostring(v22.maxPrice),
			placeholderText = v27.max,
			onTextChanged = v37,
			onFocused = v22.onFocused,
			width = uDim,
			textBoxRef = v30,
			NextSelectionLeft = v29
		})
	}))
end

return PriceRangeInput

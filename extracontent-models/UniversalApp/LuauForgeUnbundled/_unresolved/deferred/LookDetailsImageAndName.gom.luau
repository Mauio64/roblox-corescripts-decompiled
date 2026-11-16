local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)

require("@luauforge/bundled/dMc")
local module = require("@luauforge/deferred/gon")

local fitFrameVertical = AvatarExperienceDeps.RoactFitComponents.FitFrameVertical

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)

local skeleton = Foundation.Skeleton
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useStyle = UIBlox.Core.Style.useStyle

local module2 = require("@luauforge/deferred/gol")

local function LookDetailsImageAndName(props)
	local v5 = useStyle()
	local theme = v5.Theme
	local font = v5.Font

	local size_300 = v5.Tokens.Size.Size_300

	local font2 = font.Header2.Font
	local v6 = font.BaseSize * font.Header2.RelativeSize

	local name = props.name
	local isLoading = props.isLoading

	local createElement = React.createElement
	local v8 = {
		width = UDim.new(1, 0),
		contentPadding = UDim.new(0, size_300),
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}

	local createElement2 = React.createElement
	local v12 = if not module2() then props.width else nil
	local v9 = {
		LookImageFrame = createElement2(module, {
			width = v12,
			lookId = props.lookId,
			lookDetails = props.lookDetails,
			renderViewport = props.renderViewport
		}),
		LookNameContainer = 0,
		LookName = 0
	}
	local v13

	if module2() and (isLoading or name) then
		local createElement3 = React.createElement
		local v15 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.XY
		}
		local v16 = {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, props.innerPadding),
				PaddingRight = UDim.new(0, props.innerPadding)
			}),
			LookName = 0
		}
		local v17

		if isLoading then
			v17 = React.createElement(skeleton, { Size = UDim2.new(1, 0, 0, v6) })
		else
			local createElement4 = React.createElement
			local v19 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 0, 0, 0),
				Text = name,
				TextTruncate = Enum.TextTruncate.AtEnd,
				AutomaticSize = Enum.AutomaticSize.XY,
				Font = if not foundationFontFaceMigration then font2 else nil,
				FontFace = 0,
				TextSize = 0,
				TextXAlignment = 0,
				TextColor3 = 0,
				TextWrapped = true
			}

			local v21 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.TitleLarge.Font) else nil
			v19.FontFace = v21

			v19.TextSize = v6
			v19.TextXAlignment = Enum.TextXAlignment.Left
			v19.TextColor3 = theme.TextEmphasis.Color
			v17 = createElement4("TextLabel", v19)
		end

		v16.LookName = v17
		v13 = createElement3("Frame", v15, v16)
	end

	v9.LookNameContainer = v13
	local v14

	if not module2() then
		if isLoading then
			v14 = React.createElement(skeleton, {
				Size = UDim2.new(1, 0, 0, v6),
				LayoutOrder = 2
			})
		elseif name then
			local createElement3 = React.createElement
			local v16 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 0, 0, 0),
				Text = name,
				TextTruncate = Enum.TextTruncate.AtEnd,
				AutomaticSize = Enum.AutomaticSize.XY,
				Font = 0,
				FontFace = 0,
				TextSize = 0,
				TextXAlignment = 0,
				TextColor3 = 0,
				TextWrapped = true,
				LayoutOrder = 2
			}

			if foundationFontFaceMigration then
				font2 = nil
			end

			v16.Font = font2

			local v17 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.TitleLarge.Font) else nil
			v16.FontFace = v17

			v16.TextSize = v6
			v16.TextXAlignment = Enum.TextXAlignment.Left
			v16.TextColor3 = theme.TextEmphasis.Color
			v14 = createElement3("TextLabel", v16)
				or React.createElement(skeleton, {
					Size = UDim2.new(1, 0, 0, v6),
					LayoutOrder = 2
				})
		end
	end

	v9.LookName = v14
	return createElement(fitFrameVertical, v8, v9)
end

return LookDetailsImageAndName

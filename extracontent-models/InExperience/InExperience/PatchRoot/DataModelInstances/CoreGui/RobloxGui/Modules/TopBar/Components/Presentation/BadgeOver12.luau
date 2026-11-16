local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local DataHydration = require(CorePackages.Workspace.Packages.DataHydration)

local getAgeRecommendationStore = DataHydration.Game.getAgeRecommendationStore
local DataStatus = DataHydration.DataHydrationTypes.DataStatus

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagShowGameAgeRating = SharedFlags.FFlagShowGameAgeRating
local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)

return function(p)
	local v = useStyle()
	local position

	if FFlagShowGameAgeRating then
		if isSideSheetEnabled then
			position = UDim2.fromOffset(-6, -2)
		else
			position = UDim2.fromOffset(0, 2)
		end
	else
		position = p.position
	end

	local v2

	if FFlagShowGameAgeRating then
		local gameId = tostring(game.GameId)
		local v3 = React.useCallback(function(p2)
			local fetchAgeRecommendation = getAgeRecommendationStore(p2).getAndFetchAgeRecommendation(gameId)
			local status = fetchAgeRecommendation.status(p2)

			if status == DataStatus.Failed then
				return "12+"
			end

			if status == DataStatus.NotReady then
				return nil
			end

			local data = fetchAgeRecommendation.data(p2)
			local minimumAgeDisplay = data and data.minimumAgeDisplay
			return minimumAgeDisplay or "12+"
		end, { gameId })

		v2 = SignalsReact.useSignalState(v3)

		if v2 == nil then
			return nil
		end
	end

	local createElement = React.createElement
	local anchorPoint

	if FFlagShowGameAgeRating then
		anchorPoint = Vector2.new(0.5, 0)
	else
		anchorPoint = Vector2.new(0, 1)
	end

	local v3 = {
		AnchorPoint = anchorPoint,
		Position = position,
		Text = v2 or "12+",
		Font = 0,
		TextSize = 0,
		TextColor3 = 0,
		BackgroundColor3 = 0,
		BackgroundTransparency = 0,
		AutomaticSize = 0,
		LineHeight = 1.25,
		ZIndex = 2
	}
	local font

	if FFlagShowGameAgeRating then
		font = AppFonts.default:getBold()
	else
		font = AppFonts.default:getMedium()
	end

	v3.Font = font
	v3.TextSize = FFlagShowGameAgeRating and 12 or 9
	v3.TextColor3 = v.Theme.TextEmphasis.Color
	v3.BackgroundColor3 = v.Theme.BackgroundUIContrast.Color

	v3.AutomaticSize = Enum.AutomaticSize.XY

	local createElement2 = React.createElement
	local paddingTop

	if FFlagShowGameAgeRating then
		paddingTop = UDim.new(0, 2)
	end

	local paddingBottom

	if FFlagShowGameAgeRating then
		paddingBottom = UDim.new(0, 2)
	end

	local paddingLeft

	if FFlagShowGameAgeRating then
		paddingLeft = UDim.new(0, 6)
	else
		paddingLeft = UDim.new(0, 2)
	end

	local paddingRight

	if FFlagShowGameAgeRating then
		paddingRight = UDim.new(0, 6)
	else
		paddingRight = UDim.new(0, 2)
	end

	return createElement("TextLabel", v3, {
		Padding = createElement2("UIPadding", {
			PaddingTop = paddingTop,
			PaddingBottom = paddingBottom,
			PaddingLeft = paddingLeft,
			PaddingRight = paddingRight
		}),
		Shape = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) })
	})
end

local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local LoadableImage = UIBlox.App.Loading.LoadableImage
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local usePlayerCountText = require(CorePackages.Workspace.Packages.GameTile).usePlayerCountText
local OpenGameDetails = require(Modules.AvatarExperience.Common.Thunks.OpenGameDetails)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local SetItemDetailsExpanded = require(Modules.AvatarExperience.Common.Actions.SetItemDetailsExpanded)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local GameStats = require(CorePackages.Workspace.Packages.GameTile).GameStats
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local GetFFlagAXRevisedExperienceTile = require(Modules.AvatarExperience.Flags.GetFFlagAXRevisedExperienceTile)

local function formatRating(n1: number, n2: number) -- line: 69
	if n1 + n2 == 0 then
		return "--"
	end

	return `{ math.round(n1 / (n1 + n2) * 100) }%`
end
local function ExperienceCard(t1: {[any]: any}) -- line: 78
	-- upvalues: useDispatch (copy), useNavigation (copy), useStyle (copy), React (copy), usePlayerCountText (copy), getIconSize (copy), IconSize (copy), useSelector (copy), DeviceOrientationMode (copy), getUseSelectorDeepEquals (copy), SetItemDetailsExpanded (copy), AvatarScreen (copy), OpenGameDetails (copy), ImageSetLabel (copy), Images (copy), LoadableImage (copy), Skeleton (copy), GetFFlagAXRevisedExperienceTile (copy), GameStats (copy)
	local v29 = useDispatch()
	local v30 = useNavigation()
	local v31 = useStyle()
	local v32 = React.useRef(nil)
	local Font = v31.Font
	local Theme = v31.Theme
	local v37

	if t1.isHydrated and (t1.totalDownVotes and t1.totalUpVotes) then
		local totalUpVotes = t1.totalUpVotes
		local totalDownVotes = t1.totalDownVotes

		v37 = if totalUpVotes + totalDownVotes ~= 0 then `{ math.round(totalUpVotes / (totalUpVotes + totalDownVotes) * 100) }%` else "--"
	else
		v37 = "--"
	end

	local v38 = v37
	local v39 = t1.isHydrated and t1.playerCount or nil
	local v40 = usePlayerCountText(v39)
	local v41 = math.ceil(Font.BaseSize * Font.Header2.RelativeSize * 2)
	local v42 = math.ceil(Font.BaseSize * Font.Header2.RelativeSize)
	local v43 = getIconSize(IconSize.Small)
	local v44 = Font.BaseSize * Font.Body.RelativeSize
	local v45, v46 = React.useState(1)
	local v47 = useSelector(function(p1) -- line: 100
		-- upvalues: DeviceOrientationMode (copy)
		return p1.DeviceOrientation == DeviceOrientationMode.Portrait
	end, getUseSelectorDeepEquals())

	React.useEffect(function() -- line: 105
		-- upvalues: v32 (copy), v46 (copy)
		local current = v32.current

		if not current or not current.AbsoluteSize then
			return
		end

		local AbsoluteSizeX = current.AbsoluteSize.X

		if AbsoluteSizeX < 100 then
			v46(0.7)

			return
		end

		if AbsoluteSizeX < 120 then
			v46(0.8)

			return
		end

		if AbsoluteSizeX < 140 then
			v46(0.9)

			return
		end

		v46(1)
	end, {
		t1.isHydrated,
		v47,
		v32
	})

	local function onActivated() -- line: 123
		-- upvalues: v29 (copy), SetItemDetailsExpanded (copy), v30 (copy), AvatarScreen (copy), OpenGameDetails (copy), t1 (copy)
		local t2 = {
			onClose = function() -- line: 125
				-- upvalues: v29 (copy), SetItemDetailsExpanded (copy), v30 (copy), AvatarScreen (copy)
				v29(SetItemDetailsExpanded(false))
				v30.navigate(AvatarScreen.Catalog)
			end
		}

		v29(OpenGameDetails(t1.universeId, v30, t2))
	end
	local function renderFooterRow() -- line: 133
		-- upvalues: t1 (copy), v31 (copy), v43 (copy), v45 (copy), React (copy), v42 (copy), ImageSetLabel (copy), Images (copy), v38 (copy), v44 (copy), v40 (copy)
		if not t1.isHydrated then
			return nil
		end

		local Theme2 = v31.Theme
		local Font2 = v31.Font
		local uDim2 = UDim2.fromOffset(v43 * v45, v43 * v45)
		local uDim2_2 = UDim2.fromOffset(v43 * v45 + 4, 0)

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v42)
		}, {
			RatingStats = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(0.5, 1)
			}, {
				Icon = React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = uDim2,
					Image = Images["icons/status/games/rating_small"],
					ImageTransparency = Theme2.IconDefault.Transparency,
					ImageColor3 = Theme2.IconDefault.Color
				}),
				Text = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					AutomaticSize = Enum.AutomaticSize.Y,
					Font = Font2.Body.Font,
					Position = uDim2_2,
					Text = v38,
					TextSize = v44 * v45,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = Theme2.TextMuted.Color,
					TextTransparency = Theme2.TextMuted.Transparency
				})
			}),
			PlayingStats = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.XY,
				Position = UDim2.new(0.5, 4, 0, 0),
				Size = UDim2.fromScale(0.5, 1)
			}, {
				Icon = React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = uDim2,
					Image = Images["icons/status/games/people-playing_small"],
					ImageTransparency = Theme2.IconDefault.Transparency,
					ImageColor3 = Theme2.IconDefault.Color
				}),
				Text = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					AutomaticSize = Enum.AutomaticSize.Y,
					Font = Font2.Body.Font,
					Position = uDim2_2,
					Text = v40,
					TextSize = v44 * v45,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = Theme2.TextMuted.Color,
					TextTransparency = Theme2.TextMuted.Transparency
				})
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.index,
		Size = UDim2.new(1, 0, 0, 0),
		ref = v32
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, 8)
		}),
		ImageButton = React.createElement("ImageButton", {
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			Image = nil,
			Size = UDim2.fromScale(1, 1),
			[React.Event.Activated] = onActivated
		}, {
			Image = React.createElement(LoadableImage, {
				BackgroundTransparency = 1,
				Image = `rbxthumb://type=GameIcon&id={ t1.universeId }&w={ 150 }&h={ 150 }`,
				Size = UDim2.fromScale(1, 1),
				cornerRadius = UDim.new(0, 12)
			}),
			UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1
			})
		}),
		TitleShimmer = if t1.isHydrated then nil else React.createElement(Skeleton, {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, v41)
		}),
		Title = if not t1.isHydrated then nil else React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			LayoutOrder = 1,
			Font = Font.Header2.Font,
			Text = t1.name,
			TextSize = Font.BaseSize * Font.Header2.RelativeSize,
			TextColor3 = Theme.TextEmphasis.Color,
			TextTransparency = Theme.TextEmphasis.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Size = UDim2.new(1, 0, 0, v41)
		}),
		FooterShimmer = if t1.isHydrated then nil else React.createElement(Skeleton, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v42)
		}),
		Footer = if not t1.isHydrated then nil else if not GetFFlagAXRevisedExperienceTile() then renderFooterRow() else React.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MinSize = Vector2.new(0, 22)
			}),
			Footer = React.createElement(GameStats, {
				stats = {
					playerCount = t1.playerCount,
					totalUpVotes = t1.totalUpVotes,
					totalDownVotes = t1.totalDownVotes
				}
			})
		})
	})
end

return ExperienceCard

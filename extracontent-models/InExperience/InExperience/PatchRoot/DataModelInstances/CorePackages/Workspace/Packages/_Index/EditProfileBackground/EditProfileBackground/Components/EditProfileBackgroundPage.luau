local EditProfileBackground = script:FindFirstAncestor("EditProfileBackground")
local parent = EditProfileBackground.Parent
local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local editProfileBackgroundTopBar = require(EditProfileBackground.Components.editProfileBackgroundTopBar)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local RobloxAppHooks2 = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks2.useLocalUserId
local SelectionCarousel = require(EditProfileBackground.Components.SelectionCarousel)
local DisplayBackground = require(EditProfileBackground.Components.DisplayBackground)
local ProfileCustomizationNetworking = require(EditProfileBackground.Networking.ProfileCustomizationNetworking)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local RoactUtils3 = require(parent.RoactUtils)
local useEffectOnMount = RoactUtils3.Hooks.useEffectOnMount
local Foundation = require(parent.Foundation)
local View = Foundation.View
local SocialToast = require(parent.SocialToast)
local ErrorHandling = require(EditProfileBackground.Common.ErrorHandling)
local Constants = require(EditProfileBackground.Common.Constants)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(parent.InputHandlers)
local Cryo = require(parent.Cryo)

local Analytics = require(EditProfileBackground.Analytics)
local useAnalytics = Analytics.useAnalytics
local EventNames = Analytics.EventNames
local ErrorTypes = Analytics.ErrorTypes

local v = Constants.BACKGROUND_ASSET_IDS[1]

local DEFAULT_ERROR_MESSAGES = ErrorHandling.DEFAULT_ERROR_MESSAGES

local InsertService = game:GetService("InsertService")

local function preloadBackgroundAssets(p) -- 1 equivalent call inferred from this helper
	task.spawn(function()
		local joined = Cryo.Dictionary.join(
			Constants.DEFAULT_BACKGROUND_ASSET_IDS,
			Cryo.List.filter(Constants.BACKGROUND_ASSET_IDS, function(p2): boolean
				return p2 ~= v
			end)
		)

		for _, v2 in ipairs(joined) do
			local success, result = pcall(function()
				return InsertService:LoadAsset(v2)
			end)

			if success and result then
				result:Destroy()
			else
				p.fireAnalyticsEvent(EventNames.EditProfileBackgroundFailure, {
					errorType = ErrorTypes.AssetPreloadFailed
				})
			end
		end
	end)
end

local function EditProfileBackgroundPage(p)
	local v2 = useScreenSize()
	local v3 = useLocalUserId()

	local v4 = useDispatch()
	local v5 = SocialToast.useOpenToast()
	local analytics = useAnalytics()

	local v6 = useSelector(function(p2)
		if p2.GlobalGuiInset then
			return p2.GlobalGuiInset.bottom + 5
		end

		return 0
	end)

	useEffectOnMount(function()
		analytics.fireAnalyticsEvent(EventNames.EditProfileBackgroundOpened)

		local lastTime = tick()
		preloadBackgroundAssets(analytics) -- inferred equivalent call
		local statValue = tick() - lastTime

		analytics.fireAnalyticsEvent(EventNames.EditProfileBackgroundLoadingStage, {
			statValue = statValue,
			status = "loaded"
		})
	end)
	local v7

	if p.profileBackgroundData and p.profileBackgroundData.assetId then
		v7 = p.profileBackgroundData.assetId
	else
		v7 = v
	end

	local state, setState = React.useState(nil)

	local currentBackgroundId = state or v7

	local v8 = React.useMemo(function()
		local width = math.min(640, v2.X)
		local buttonsPerRow = width >= 540 and 8 or 4
		local numRows = math.ceil(8 / buttonsPerRow)
		local buttonSize = (width - 32 - (buttonsPerRow - 1) * 16) / buttonsPerRow
		local carouselHeight = numRows * buttonSize + (numRows + 1) * 16
		local contentAreaHeight = v2.Y - 48 - 40 - 24 - v6
		return {
			width = width,
			buttonSize = buttonSize,
			carouselHeight = carouselHeight,
			contentAreaHeight = contentAreaHeight,
			displayBackgroundHeight = contentAreaHeight - carouselHeight,
			buttonsPerRow = buttonsPerRow,
			numRows = numRows
		}
	end, { v2, v6 })

	local v9 = useNavigation()

	local function onClose() -- 1 equivalent call inferred from this helper
		if p.onBackgroundChanged then
			p.onBackgroundChanged()
		end

		v9.goBack()
	end

	local function onBackgroundSelected(p2: number)
		analytics.fireAnalyticsEvent(EventNames.BackgroundSelected, { backgroundId = p2 })

		setState(p2)

		task.spawn(function()
			local v10 = {
				profileEntity = { id = tostring(v3), type = "User" },
				customizedComponents = {
					profileBackground = { assetId = p2 }
				}
			}

			v4(ProfileCustomizationNetworking.UpdateProfileCustomization.API(v10)):andThen(function(_)
				if p.onBackgroundChanged then
					p.onBackgroundChanged()
				end
			end):catch(function(p3)
				analytics.fireAnalyticsEvent(EventNames.EditProfileBackgroundFailure, {
					errorType = ErrorTypes.BackgroundSaveFailed,
					errorCode = tostring(p3 and p3.StatusCode or "unknown")
				})

				v5({
					toastTitle = DEFAULT_ERROR_MESSAGES.SAVE_BACKGROUND,
					iconImage = { Image = "icons/actions/error" }
				})
			end)
		end)
	end

	return React.createElement(FocusNavigableSurfaceWrapper, {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isIsolated = true,
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onClose() -- inferred equivalent call
					object:cancel()
				end)
			}
		}
	}, { React.createElement(View, {
			tag = "size-full bg-surface-0 anchor-top-right position-top-right"
		}, {
			SizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(640, 1e999)
			}),
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 24)
			}),
			TopPadding = React.createElement(View, { tag = "size-full-500" }),
			TopBar = React.createElement(editProfileBackgroundTopBar, {
				layoutOrder = 1,
				onClose = onClose
			}),
			ContentArea = React.createElement(
				View,
				{
					Size = UDim2.new(1, 0, 0, v8.contentAreaHeight),
					LayoutOrder = 2
				},
				{
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 0)
					}),
					BackgroundDisplay = React.createElement(DisplayBackground, {
						LayoutOrder = 1,
						height = v8.displayBackgroundHeight,
						currentBackgroundId = currentBackgroundId,
						userId = tonumber(v3),
						analytics = analytics
					}),
					SelectionCarousel = React.createElement(SelectionCarousel, {
						LayoutOrder = 2,
						height = v8.carouselHeight,
						width = v8.width,
						buttonSize = v8.buttonSize,
						buttonsPerRow = v8.buttonsPerRow,
						numRows = v8.numRows,
						onBackgroundSelected = onBackgroundSelected,
						currentBackgroundId = currentBackgroundId
					})
				}
			)
		}) })
end

return EditProfileBackgroundPage

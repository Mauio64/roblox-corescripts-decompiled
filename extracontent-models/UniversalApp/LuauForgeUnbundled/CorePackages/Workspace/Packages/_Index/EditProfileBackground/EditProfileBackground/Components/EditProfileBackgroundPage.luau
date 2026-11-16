local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/Navigation").useNavigation
local editProfileBackgroundTopBar = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Components/editProfileBackgroundTopBar")
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/RobloxAppHooks").useScreenSize
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/RobloxAppHooks").useLocalUserId
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Components/SelectionCarousel")
local DisplayBackground = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Components/DisplayBackground")
local ProfileCustomizationNetworking = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Networking/ProfileCustomizationNetworking")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/RoactUtils").Hooks.RoactRodux.useSelector
local useEffectOnMount = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/RoactUtils").Hooks.useEffectOnMount
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/Foundation").View
local SocialToast = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/SocialToast")
local ErrorHandling = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Common/ErrorHandling")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Common/Constants")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/FocusNavigationUtils")
local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/InputHandlers")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/Cryo")

local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Analytics")
local useAnalytics = Analytics.useAnalytics
local eventNames = Analytics.EventNames
local errorTypes = Analytics.ErrorTypes

local v5 = Constants.BACKGROUND_ASSET_IDS[1]

local DEFAULT_ERROR_MESSAGES = ErrorHandling.DEFAULT_ERROR_MESSAGES

local InsertService = game:GetService("InsertService")

local function preloadBackgroundAssets(p2)
	task.spawn(function()
		local joined = Cryo.Dictionary.join(
			Constants.DEFAULT_BACKGROUND_ASSET_IDS,
			Cryo.List.filter(Constants.BACKGROUND_ASSET_IDS, function(p3): boolean
				return p3 ~= v5
			end)
		)

		for i, v6 in ipairs(joined) do
			local success, result = pcall(function()
				return InsertService:LoadAsset(v6)
			end)

			if success and result then
				result:Destroy()
			else
				p2.fireAnalyticsEvent(eventNames.EditProfileBackgroundFailure, {
					errorType = errorTypes.AssetPreloadFailed
				})
			end
		end
	end)
end

local function EditProfileBackgroundPage(p2)
	local v6 = useScreenSize()
	local v7 = useLocalUserId()

	local v8 = useDispatch()
	local v9 = SocialToast.useOpenToast()
	local v10 = useAnalytics()

	local v11 = useSelector(function(p3)
		if p3.GlobalGuiInset then
			return p3.GlobalGuiInset.bottom + 5
		end

		return 0
	end)

	useEffectOnMount(function()
		v10.fireAnalyticsEvent(eventNames.EditProfileBackgroundOpened)

		local lastTime = tick()

		local v12 = v10
		task.spawn(function()
			local joined = Cryo.Dictionary.join(
				Constants.DEFAULT_BACKGROUND_ASSET_IDS,
				Cryo.List.filter(Constants.BACKGROUND_ASSET_IDS, function(p3): boolean
					return p3 ~= v5
				end)
			)

			for i, v13 in ipairs(joined) do
				local success, result = pcall(function()
					return InsertService:LoadAsset(v13)
				end)

				if success and result then
					result:Destroy()
				else
					v12.fireAnalyticsEvent(eventNames.EditProfileBackgroundFailure, {
						errorType = errorTypes.AssetPreloadFailed
					})
				end
			end
		end)

		local v13 = tick() - lastTime

		v10.fireAnalyticsEvent(eventNames.EditProfileBackgroundLoadingStage, {
			statValue = v13,
			status = "loaded"
		})
	end)
	local v12

	if p2.profileBackgroundData and p2.profileBackgroundData.assetId then
		v12 = p2.profileBackgroundData.assetId
	else
		v12 = v5
	end

	local state, setState = React.useState(nil)

	local v13 = state or v12

	local v14 = React.useMemo(function()
		local v15 = math.min(640, v6.X)
		local v16 = v15 >= 540 and 8 or 4
		local v17 = math.ceil(8 / v16)
		local v18 = (v15 - 32 - (v16 - 1) * 16) / v16
		local v19 = v17 * v18 + (v17 + 1) * 16
		local v20 = v6.Y - 48 - 40 - 24 - v11
		return {
			width = v15,
			buttonSize = v18,
			carouselHeight = v19,
			contentAreaHeight = v20,
			displayBackgroundHeight = v20 - v19,
			buttonsPerRow = v16,
			numRows = v17
		}
	end, { v6, v11 })

	local v15 = useNavigation()

	local function onBackgroundSelected(p3)
		v10.fireAnalyticsEvent(eventNames.BackgroundSelected, { backgroundId = p3 })

		setState(p3)

		task.spawn(function()
			local v16 = {
				profileEntity = { id = tostring(v7), type = "User" },
				customizedComponents = {
					profileBackground = { assetId = p3 }
				}
			}

			v8(ProfileCustomizationNetworking.UpdateProfileCustomization.API(v16)):andThen(function(p4)
				if p2.onBackgroundChanged then
					p2.onBackgroundChanged()
				end
			end):catch(function(p4)
				v10.fireAnalyticsEvent(eventNames.EditProfileBackgroundFailure, {
					errorType = errorTypes.BackgroundSaveFailed,
					errorCode = tostring(p4 and p4.StatusCode or "unknown")
				})

				v9({
					toastTitle = DEFAULT_ERROR_MESSAGES.SAVE_BACKGROUND,
					iconImage = { Image = "icons/actions/error" }
				})
			end)
		end)
	end

	return React.createElement(focusNavigableSurfaceWrapper, {
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isIsolated = true,
		customEventHandlers = {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					if p2.onBackgroundChanged then
						p2.onBackgroundChanged()
					end

					v15.goBack()

					object:cancel()
				end)
			}
		}
	}, { React.createElement(
			view,
			{ tag = "size-full bg-surface-0 anchor-top-right position-top-right" },
			{
				SizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(640, 1e999)
				}),
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 24)
				}),
				TopPadding = React.createElement(view, { tag = "size-full-500" }),
				TopBar = React.createElement(editProfileBackgroundTopBar, {
					layoutOrder = 1,
					onClose = function()
						if p2.onBackgroundChanged then
							p2.onBackgroundChanged()
						end

						v15.goBack()
					end
				}),
				ContentArea = React.createElement(
					view,
					{
						Size = UDim2.new(1, 0, 0, v14.contentAreaHeight),
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
							height = v14.displayBackgroundHeight,
							currentBackgroundId = v13,
							userId = tonumber(v7),
							analytics = v10
						}),
						SelectionCarousel = React.createElement(module3, {
							LayoutOrder = 2,
							height = v14.carouselHeight,
							width = v14.width,
							buttonSize = v14.buttonSize,
							buttonsPerRow = v14.buttonsPerRow,
							numRows = v14.numRows,
							onBackgroundSelected = onBackgroundSelected,
							currentBackgroundId = v13
						})
					}
				)
			}
		) })
end

return EditProfileBackgroundPage

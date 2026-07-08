local EditProfileBackground = script:FindFirstAncestor("EditProfileBackground")
local EditProfileBackgroundParent = EditProfileBackground.Parent
local React = require(EditProfileBackgroundParent.React)
local useNavigation = require(EditProfileBackgroundParent.Navigation).useNavigation
local editProfileBackgroundTopBar = require(EditProfileBackground.Components.editProfileBackgroundTopBar)
local useScreenSize = require(EditProfileBackgroundParent.RobloxAppHooks).useScreenSize
local useLocalUserId = require(EditProfileBackgroundParent.RobloxAppHooks).useLocalUserId
local SelectionCarousel = require(EditProfileBackground.Components.SelectionCarousel)
local DisplayBackground = require(EditProfileBackground.Components.DisplayBackground)
local ProfileCustomizationNetworking = require(EditProfileBackground.Networking.ProfileCustomizationNetworking)
local useDispatch = require(EditProfileBackgroundParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(EditProfileBackgroundParent.RoactUtils).Hooks.RoactRodux.useSelector
local useEffectOnMount = require(EditProfileBackgroundParent.RoactUtils).Hooks.useEffectOnMount
local View = require(EditProfileBackgroundParent.Foundation).View
local SocialToast = require(EditProfileBackgroundParent.SocialToast)
local ErrorHandling = require(EditProfileBackground.Common.ErrorHandling)
local Constants = require(EditProfileBackground.Common.Constants)
local FocusNavigationUtils = require(EditProfileBackgroundParent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(EditProfileBackgroundParent.InputHandlers)
local Cryo = require(EditProfileBackgroundParent.Cryo)
local Analytics = require(EditProfileBackground.Analytics)
local useAnalytics = Analytics.useAnalytics
local EventNames = Analytics.EventNames
local ErrorTypes = Analytics.ErrorTypes
local v28 = Constants.BACKGROUND_ASSET_IDS[1]
local DEFAULT_ERROR_MESSAGES = ErrorHandling.DEFAULT_ERROR_MESSAGES
local InsertService = game:GetService("InsertService")

local function preloadBackgroundAssets(p1) -- line: 52
	-- upvalues: Cryo (copy), Constants (copy), v28 (copy), InsertService (copy), EventNames (copy), ErrorTypes (copy)
	task.spawn(function() -- line: 53
		-- upvalues: Cryo (copy), Constants (copy), v28 (copy), InsertService (copy), p1 (copy), EventNames (copy), ErrorTypes (copy)
		local v47 = Cryo.Dictionary.join(Constants.DEFAULT_BACKGROUND_ASSET_IDS, Cryo.List.filter(Constants.BACKGROUND_ASSET_IDS, function(p2) -- line: 57
			-- upvalues: v28 (copy)
			return p2 ~= v28
		end))

		for _, v in ipairs(v47) do
			local ok, result = pcall(function() -- line: 63
				-- upvalues: InsertService (copy), v (copy)
				return InsertService:LoadAsset(v)
			end)

			if ok and result then
				result:Destroy()
			else
				p1.fireAnalyticsEvent(EventNames.EditProfileBackgroundFailure, {
					errorType = ErrorTypes.AssetPreloadFailed
				})
			end
		end
	end)
end
local function EditProfileBackgroundPage(t1: {[any]: any}) -- line: 84
	-- upvalues: useScreenSize (copy), useLocalUserId (copy), useDispatch (copy), SocialToast (copy), useAnalytics (copy), useSelector (copy), useEffectOnMount (copy), EventNames (copy), Cryo (copy), Constants (copy), v28 (copy), InsertService (copy), ErrorTypes (copy), React (copy), useNavigation (copy), ProfileCustomizationNetworking (copy), DEFAULT_ERROR_MESSAGES (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), View (copy), editProfileBackgroundTopBar (copy), DisplayBackground (copy), SelectionCarousel (copy)
	local v35 = useScreenSize()
	local v36 = useLocalUserId()
	local v37 = useDispatch()
	local v38 = SocialToast.useOpenToast()
	local v39 = useAnalytics()
	local v40 = useSelector(function(p3) -- line: 92
		if p3.GlobalGuiInset then
			return p3.GlobalGuiInset.bottom + 5
		end

		return 0
	end)

	useEffectOnMount(function() -- line: 96
		-- upvalues: v39 (copy), EventNames (copy), Cryo (copy), Constants (copy), v28 (copy), InsertService (copy), ErrorTypes (copy)
		v39.fireAnalyticsEvent(EventNames.EditProfileBackgroundOpened)

		local timestamp = tick()
		local v54 = v39

		task.spawn(function() -- line: 53
			-- upvalues: Cryo (copy), Constants (copy), v28 (copy), InsertService (copy), v54 (copy), EventNames (copy), ErrorTypes (copy)
			local v66 = Cryo.Dictionary.join(Constants.DEFAULT_BACKGROUND_ASSET_IDS, Cryo.List.filter(Constants.BACKGROUND_ASSET_IDS, function(p4) -- line: 57
				-- upvalues: v28 (copy)
				return p4 ~= v28
			end))

			for _, v in ipairs(v66) do
				local ok, result = pcall(function() -- line: 63
					-- upvalues: InsertService (copy), v (copy)
					return InsertService:LoadAsset(v)
				end)

				if ok and result then
					result:Destroy()
				else
					v54.fireAnalyticsEvent(EventNames.EditProfileBackgroundFailure, {
						errorType = ErrorTypes.AssetPreloadFailed
					})
				end
			end
		end)

		local v55 = tick() - timestamp

		v39.fireAnalyticsEvent(EventNames.EditProfileBackgroundLoadingStage, {
			status = "loaded",
			statValue = v55
		})
	end)

	local v41 = if not t1.profileBackgroundData or not t1.profileBackgroundData.assetId then v28 else t1.profileBackgroundData.assetId
	local v42, v43 = React.useState(nil)
	local v44 = v42 or v41
	local v45 = React.useMemo(function() -- line: 121
		-- upvalues: v35 (copy), v40 (copy)
		local v56 = math.min(640, v35.X)
		local v57 = not (v56 >= 540) and 4 or 8
		local v58 = math.ceil(8 / v57)
		local v59 = (v56 - 32 - (v57 - 1) * 16) / v57
		local v60 = v58 * v59 + (v58 + 1) * 16
		local v61 = v35.Y - 48 - 40 - 24 - v40
		local v62 = v61 - v60

		return {
			width = v56,
			buttonSize = v59,
			carouselHeight = v60,
			contentAreaHeight = v61,
			displayBackgroundHeight = v62,
			buttonsPerRow = v57,
			numRows = v58
		}
	end, {
		v35,
		v40
	})
	local v46 = useNavigation()

	return React.createElement(FocusNavigableSurfaceWrapper, {
		isIsolated = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p5) -- line: 197
					-- upvalues: t1 (copy), v46 (copy)
					if t1.onBackgroundChanged then
						t1.onBackgroundChanged()
					end

					v46.goBack()
					p5:cancel()
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
		TopPadding = React.createElement(View, {
			tag = "size-full-500"
		}),
		TopBar = React.createElement(editProfileBackgroundTopBar, {
			layoutOrder = 1,
			onClose = function() -- line: 143
				-- upvalues: t1 (copy), v46 (copy)
				if t1.onBackgroundChanged then
					t1.onBackgroundChanged()
				end

				v46.goBack()
			end
		}),
		ContentArea = React.createElement(View, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v45.contentAreaHeight)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 0)
			}),
			BackgroundDisplay = React.createElement(DisplayBackground, {
				LayoutOrder = 1,
				height = v45.displayBackgroundHeight,
				currentBackgroundId = v44,
				userId = tonumber(v36),
				analytics = v39
			}),
			SelectionCarousel = React.createElement(SelectionCarousel, {
				LayoutOrder = 2,
				height = v45.carouselHeight,
				width = v45.width,
				buttonSize = v45.buttonSize,
				buttonsPerRow = v45.buttonsPerRow,
				numRows = v45.numRows,
				onBackgroundSelected = function(n1: number) -- line: 151
					-- upvalues: v39 (copy), EventNames (copy), v43 (copy), v36 (copy), v37 (copy), ProfileCustomizationNetworking (copy), t1 (copy), ErrorTypes (copy), v38 (copy), DEFAULT_ERROR_MESSAGES (copy)
					v39.fireAnalyticsEvent(EventNames.BackgroundSelected, {
						backgroundId = n1
					})
					v43(n1)
					task.spawn(function() -- line: 158
						-- upvalues: v36 (copy), n1 (copy), v37 (copy), ProfileCustomizationNetworking (copy), t1 (copy), v39 (copy), EventNames (copy), ErrorTypes (copy), v38 (copy), DEFAULT_ERROR_MESSAGES (copy)
						local t2 = {
							profileEntity = {
								type = "User",
								id = tostring(v36)
							},
							customizedComponents = {
								profileBackground = {
									assetId = n1
								}
							}
						}

						v37(ProfileCustomizationNetworking.UpdateProfileCustomization.API(t2)):andThen(function(_) -- line: 172
							-- upvalues: t1 (copy)
							if t1.onBackgroundChanged then
								t1.onBackgroundChanged()
							end
						end):catch(function(p7) -- line: 177
							-- upvalues: v39 (copy), EventNames (copy), ErrorTypes (copy), v38 (copy), DEFAULT_ERROR_MESSAGES (copy)
							v39.fireAnalyticsEvent(EventNames.EditProfileBackgroundFailure, {
								errorType = ErrorTypes.BackgroundSaveFailed,
								errorCode = tostring(p7 and p7.StatusCode or "unknown")
							})
							v38({
								toastTitle = DEFAULT_ERROR_MESSAGES.SAVE_BACKGROUND,
								iconImage = {
									Image = "icons/actions/error"
								}
							})
						end)
					end)
				end,
				currentBackgroundId = v44
			})
		})
	}) })
end

return EditProfileBackgroundPage

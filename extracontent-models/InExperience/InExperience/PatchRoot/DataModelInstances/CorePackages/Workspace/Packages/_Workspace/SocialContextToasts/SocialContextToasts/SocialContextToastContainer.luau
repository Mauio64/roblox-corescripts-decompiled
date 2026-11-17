local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local SocialContextToasts = script:FindFirstAncestor("SocialContextToasts")
local parent = SocialContextToasts.Parent

local RobloxAppLocales = require(parent.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local SocialContextToastDispatcher = require(SocialContextToasts.SocialContextToastDispatcher)
local ToastRoot = require(SocialContextToasts.ToastRoot)
local ToastTypes = require(SocialContextToasts.Enums.ToastTypes)

local ConfirmationModalRoot = require(SocialContextToasts.ConfirmationModalRoot)
local DisplayOrder = require(parent.DisplayOrder)
local ReactRoblox = require(parent.ReactRoblox)
local React = require(parent.React)
local Rodux = require(parent.Rodux)
local RoactRodux = require(parent.RoactRodux)
local Cryo = require(parent.Cryo)

local DisplayOrderEnum = DisplayOrder.DisplayOrderEnum

local Style = require(parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme

local function renderWithStyleProvider(p) -- 1 equivalent call inferred from this helper
	return React.createElement(StyleProviderWithDefaultTheme, {}, p)
end

local function SocialContextToastContainer(services, gameId, placeId)
	local socialContextToast = Instance.new("Folder")
	socialContextToast.Name = "SocialContextToast"
	socialContextToast.Parent = CoreGui

	local v = {
		ToastContent = { toastType = ToastTypes.None }
	}

	local reducer = Rodux.createReducer({}, {
		SetToastContent = function(p, p2)
			return (Cryo.Dictionary.join(p, { ToastContent = p2.toastContent }))
		end,
		SetConfirmationModal = function(p, p2)
			return (Cryo.Dictionary.join(p, {
				ConfirmationModal = {
					isOpen = p2.isConfirmationModalOpen,
					closeCallback = p2.closeCallback
				}
			}))
		end
	})

	local store = Rodux.Store.new(reducer, v, { Rodux.thunkMiddleware })

	local element = React.createElement(RoactRodux.StoreProvider, { store = store }, {
		StyleProvider = renderWithStyleProvider({ -- inferred equivalent call
			LocalizationProvider = React.createElement(
				LocalizationProvider,
				{
					localization = Localization.new(LocalizationService.RobloxLocaleId)
				},
				{
					SocialContextToastGUI = React.createElement(
						"ScreenGui",
						{
							DisplayOrder = DisplayOrderEnum.SocialContextToastContainer,
							ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
						},
						{
							ToastDispatcher = React.createElement(SocialContextToastDispatcher, {
								services = services,
								gameId = gameId,
								placeId = placeId
							}),
							ToastRoot = React.createElement(ToastRoot, {
								analyticsProps = {
									eventIngest = services.eventIngest,
									gameId = gameId,
									placeId = placeId
								}
							}),
							ConfirmationModalRoot = React.createElement(ConfirmationModalRoot)
						}
					)
				}
			)
		})
	})

	ReactRoblox.createRoot(socialContextToast):render(element)

	return element
end

return SocialContextToastContainer

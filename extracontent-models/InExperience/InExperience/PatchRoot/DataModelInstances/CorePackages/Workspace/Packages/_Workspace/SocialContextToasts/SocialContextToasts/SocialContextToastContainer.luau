local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local SocialContextToasts = script:FindFirstAncestor("SocialContextToasts")
local SocialContextToastsParent = SocialContextToasts.Parent
local Localization = require(SocialContextToastsParent.RobloxAppLocales).Localization
local LocalizationProvider = require(SocialContextToastsParent.Localization).LocalizationProvider
local SocialContextToastDispatcher = require(SocialContextToasts.SocialContextToastDispatcher)
local ToastRoot = require(SocialContextToasts.ToastRoot)
local ToastTypes = require(SocialContextToasts.Enums.ToastTypes)
local ConfirmationModalRoot = require(SocialContextToasts.ConfirmationModalRoot)
local DisplayOrder = require(SocialContextToastsParent.DisplayOrder)
local ReactRoblox = require(SocialContextToastsParent.ReactRoblox)
local React = require(SocialContextToastsParent.React)
local Rodux = require(SocialContextToastsParent.Rodux)
local RoactRodux = require(SocialContextToastsParent.RoactRodux)
local Cryo = require(SocialContextToastsParent.Cryo)
local DisplayOrderEnum = DisplayOrder.DisplayOrderEnum
local StyleProviderWithDefaultTheme = require(SocialContextToastsParent.Style).StyleProviderWithDefaultTheme
local GetFFlagSocialContextToastEventStream = require(SocialContextToastsParent.SharedFlags).GetFFlagSocialContextToastEventStream

local function renderWithStyleProvider(p1) -- line: 29
	-- upvalues: React (copy), StyleProviderWithDefaultTheme (copy)
	return React.createElement(StyleProviderWithDefaultTheme, {}, p1)
end
local function SocialContextToastContainer(p2, p3, p4) -- line: 33
	-- upvalues: CoreGui (copy), ToastTypes (copy), Rodux (copy), Cryo (copy), React (copy), RoactRodux (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), DisplayOrderEnum (copy), SocialContextToastDispatcher (copy), ToastRoot (copy), GetFFlagSocialContextToastEventStream (copy), ConfirmationModalRoot (copy), StyleProviderWithDefaultTheme (copy), ReactRoblox (copy)
	local Folder = Instance.new("Folder")

	Folder.Name = "SocialContextToast"
	Folder.Parent = CoreGui

	local t1 = {
		ToastContent = {
			toastType = ToastTypes.None
		}
	}
	local v28 = Rodux.createReducer({}, {
		SetToastContent = function(p5, p6) -- line: 50
			-- upvalues: Cryo (copy)
			return (Cryo.Dictionary.join(p5, {
				ToastContent = p6.toastContent
			}))
		end,
		SetConfirmationModal = function(p7, p8) -- line: 56
			-- upvalues: Cryo (copy)
			return (Cryo.Dictionary.join(p7, {
				ConfirmationModal = {
					isOpen = p8.isConfirmationModalOpen,
					closeCallback = p8.closeCallback
				}
			}))
		end
	})
	local v29 = Rodux.Store.new(v28, t1, { Rodux.thunkMiddleware })
	local createElement = React.createElement
	local StoreProvider = RoactRodux.StoreProvider
	local t2 = {
		store = v29
	}
	local t3 = {}
	local t4 = {
		LocalizationProvider = React.createElement(LocalizationProvider, {
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		}, {
			SocialContextToastGUI = React.createElement("ScreenGui", {
				DisplayOrder = DisplayOrderEnum.SocialContextToastContainer,
				ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
			}, {
				ToastDispatcher = React.createElement(SocialContextToastDispatcher, {
					services = p2,
					gameId = p3,
					placeId = p4
				}),
				ToastRoot = React.createElement(ToastRoot, {
					analyticsProps = if not GetFFlagSocialContextToastEventStream() then nil else {
						eventIngest = p2.eventIngest,
						gameId = p3,
						placeId = p4
					}
				}),
				ConfirmationModalRoot = React.createElement(ConfirmationModalRoot)
			})
		})
	}

	t3.StyleProvider = React.createElement(StyleProviderWithDefaultTheme, {}, t4)

	local v35 = createElement(StoreProvider, t2, t3)

	ReactRoblox.createRoot(Folder):render(v35)

	return v35
end

return SocialContextToastContainer

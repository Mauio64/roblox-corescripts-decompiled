local module = require("@luauforge/bundled/eRR")
local module2 = require("@luauforge/bundled/eRS")
local useNavigation = module2.useNavigation
local useNavigationFocus = module2.useNavigationFocus
local module3 = require("@luauforge/bundled/eRT")
local appPage = require("@luauforge/bundled/eRU").AppPage

local createSingleUserRecentActivityEventFeed = require("@luauforge/bundled/eRV").createSingleUserRecentActivityEventFeed

local module4 = require("@luauforge/bundled/eRW")
local fFlagEnableRecentActivityInspectAndBuy = module4.FFlagEnableRecentActivityInspectAndBuy
local fFlagEnableRecentActivitySingleItemDetails = module4.FFlagEnableRecentActivitySingleItemDetails

local module5 = require("@luauforge/bundled/eRX")

local function UserRecentActivityContainer()
	local v5 = useNavigation()
	local v6 = useNavigationFocus()
	local v7 = module3.useOrientation() == module3.Keys.Portrait

	local state, setState = module.useState(false)

	module.useEffect(function()
		if v6 then
			setState(false)
		end
	end, { v6 })

	local v8 = module.useCallback(function()
		if state then
			return
		end

		v5.goBack()
	end, { v5, state })

	local v9 = tonumber(v5.getParam("userId"))
	local param = v5.getParam("primaryName")

	local v10 = module.useCallback(function(list, p2)
		if fFlagEnableRecentActivitySingleItemDetails and #list == 1 then
			local v11 = tostring(list[1])
			local v12 = "Asset" .. v11

			setState(true)
			v5.push(appPage.AvatarExperienceWrapperTransparent, {
				detail = v12,
				extraProps = {
					routeName = "ItemDetails",
					params = {
						fromProfile = false,
						detail = v12,
						itemId = v11,
						itemType = "Asset",
						mountAsFullView = v7 and true or nil,
						showFullWithNoPeekView = not v7 or nil,
						isFirstItemDetails = true,
						mountAnimation = false,
						itemDetailsPeekViewRefs = {}
					}
				}
			})
		elseif fFlagEnableRecentActivityInspectAndBuy then
			v5.navigate(appPage.RecentActivityInspectAndBuy, {
				assetIds = list,
				userId = p2
			})
		end
	end, { v5, v7 })

	local v13 = {
		onClose = v8,
		isOpen = if fFlagEnableRecentActivitySingleItemDetails then not state else nil,
		feedSource = module.useMemo(function()
			if v9 == nil then
				return nil
			end

			return (createSingleUserRecentActivityEventFeed({
				userId = v9,
				primaryName = param
			}))
		end, { v9, param }),
		userId = v9,
		primaryName = param,
		onAvatarActivated = v10
	}
	return module.createElement(module5, v13)
end

return UserRecentActivityContainer

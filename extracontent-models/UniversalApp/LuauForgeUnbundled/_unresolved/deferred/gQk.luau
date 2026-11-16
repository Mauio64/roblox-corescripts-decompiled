local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation

local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local navigateWithLock = AvatarExperienceNavigation.Thunks.NavigateWithLock
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local module2 = require("@luauforge/bundled/dPN")
local module3 = require("@luauforge/bundled/dPG")

return {
	useNavigateToCatalogCategory = function()
		local v5 = useDispatch()
		local v6 = useNavigation()
		return React.useMemo(function()
			local v7 = v5
			local v8 = v6
			return function(p2, p3)
				module2(module3.getCatalogSelectionStore, p2.CategoryId, p2.SubcategoryId, {
					analytics = p3 and p3.analytics,
					source = "EditorShopForMore"
				})

				v7(navigateWithLock(function()
					if v8 then
						v8.navigate(avatarScreen.Catalog)
					end

					if p3 and p3.onAfterNavigate then
						p3.onAfterNavigate()
					end
				end))
			end
		end, { v5, v6 })
	end,
	makeNavigateToCatalogCategory = function(callback, p2)
		return function(p3, p4)
			module2(module3.getCatalogSelectionStore, p3.CategoryId, p3.SubcategoryId, {
				analytics = p4 and p4.analytics,
				source = "EditorShopForMore"
			})

			callback(navigateWithLock(function()
				if p2 then
					p2.navigate(avatarScreen.Catalog)
				end

				if p4 and p4.onAfterNavigate then
					p4.onAfterNavigate()
				end
			end))
		end
	end
}

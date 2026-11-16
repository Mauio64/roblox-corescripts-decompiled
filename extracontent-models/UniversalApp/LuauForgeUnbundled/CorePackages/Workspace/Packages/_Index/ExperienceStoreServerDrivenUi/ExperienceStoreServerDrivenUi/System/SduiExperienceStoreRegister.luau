local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/React")

local fFlagSduiGameItemsComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SharedFlags").FFlagSduiGameItemsComponent
local fFlagSduiLocalFeedFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SharedFlags").FFlagSduiLocalFeedFilter

local registerExperienceStoreActions = require("@game/CorePackages/Workspace/Packages/_Index/ExperienceStoreServerDrivenUi/ExperienceStoreServerDrivenUi/Actions/registerExperienceStoreActions")

local registerExperienceStoreComponents = require("@game/CorePackages/Workspace/Packages/_Index/ExperienceStoreServerDrivenUi/ExperienceStoreServerDrivenUi/System/registerExperienceStoreComponents")

local function SduiExperienceStoreRegister(): nil
	React.useEffect(function()
		registerExperienceStoreActions()

		if fFlagSduiGameItemsComponent or fFlagSduiLocalFeedFilter then
			registerExperienceStoreComponents()
		end
	end, {})
	return nil
end

return React.memo(SduiExperienceStoreRegister)

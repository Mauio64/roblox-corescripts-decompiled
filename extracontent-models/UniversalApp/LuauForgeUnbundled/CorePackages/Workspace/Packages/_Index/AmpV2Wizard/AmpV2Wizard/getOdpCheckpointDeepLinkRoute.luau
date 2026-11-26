local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/RobloxAppEnums").AppPage

return function(p2)
	local odpSessionId = p2.odpSessionId

	if
		type(odpSessionId) == "string"
		and string.match(
			odpSessionId,
			"^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
		)
	then
		return {
			{
				{
					name = appPage.AmpV2Wizard,
					extraProps = {
						flow = {
							name = "OdpCheckpointResume",
							props = { odpSessionId = odpSessionId }
						},
						surface = "OdpWebViewHandoff"
					}
				}
			}
		}
	end

	return nil
end

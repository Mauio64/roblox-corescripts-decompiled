local RobloxAppEnums = require(script.Parent.Parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

return function(p)
	local odpSessionId = p.odpSessionId

	if
		type(odpSessionId) == "string"
		and string.match(odpSessionId, "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$")
	then
		return {
			{
				{
					name = AppPage.AmpV2Wizard,
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

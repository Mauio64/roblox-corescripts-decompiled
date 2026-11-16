local CoreGui = game:GetService("CoreGui")

local pages = CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules"):WaitForChild("Settings"):WaitForChild("Pages")
local ReportAbuseMenuContainerPage = require(pages:WaitForChild("ReportAbuseMenuContainerPage"))

return ReportAbuseMenuContainerPage

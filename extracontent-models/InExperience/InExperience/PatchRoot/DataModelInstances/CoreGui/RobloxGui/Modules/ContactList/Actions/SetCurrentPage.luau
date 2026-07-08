local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ContactList = CoreGui:WaitForChild("RobloxGui").Modules.ContactList

require(ContactList.Enums.Pages)

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1) -- line: 9
	return {
		page = p1
	}
end)

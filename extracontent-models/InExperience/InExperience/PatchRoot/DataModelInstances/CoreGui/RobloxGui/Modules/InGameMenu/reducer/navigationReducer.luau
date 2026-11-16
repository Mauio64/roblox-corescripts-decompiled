local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Cryo = InGameMenuDependencies.Cryo
local parent = script.Parent.Parent
local Pages = require(parent.Components.Pages)
local NavigateBack = require(parent.Actions.NavigateBack)
local SetCurrentPage = require(parent.Actions.SetCurrentPage)

return function(data, p)
	local page = Pages.pagesByKey[data.menuPage]

	if p.type == NavigateBack.name then
		if data.respawn.dialogOpen then
			return Cryo.Dictionary.join(data, {
				respawn = Cryo.Dictionary.join(data.respawn, { dialogOpen = false })
			})
		end

		if data.report.dialogOpen then
			return Cryo.Dictionary.join(data, {
				report = Cryo.Dictionary.join(data.report, { dialogOpen = false })
			})
		end

		if data.menuPage then
			local parentPage = page.parentPage

			if parentPage ~= nil then
				return Cryo.Dictionary.join(data, { menuPage = parentPage })
			end
		end
	elseif p.type == SetCurrentPage.name then
		return Cryo.Dictionary.join(data, { currentlyOpenBubble = Cryo.None })
	end

	return data
end

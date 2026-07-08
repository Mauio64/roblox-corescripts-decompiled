local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.InGameMenuDependencies).Cryo
local ParentParent = script.Parent.Parent
local Pages = require(ParentParent.Components.Pages)
local NavigateBack = require(ParentParent.Actions.NavigateBack)
local SetCurrentPage = require(ParentParent.Actions.SetCurrentPage)

return function(p1, p2) -- line: 12
	-- upvalues: Pages (copy), NavigateBack (copy), Cryo (copy), SetCurrentPage (copy)
	local v9 = Pages.pagesByKey[p1.menuPage]

	if p2.type == NavigateBack.name then
		if p1.respawn.dialogOpen then
			return Cryo.Dictionary.join(p1, {
				respawn = Cryo.Dictionary.join(p1.respawn, {
					dialogOpen = false
				})
			})
		end

		if p1.report.dialogOpen then
			return Cryo.Dictionary.join(p1, {
				report = Cryo.Dictionary.join(p1.report, {
					dialogOpen = false
				})
			})
		end

		if p1.menuPage then
			local parentPage = v9.parentPage

			if parentPage ~= nil then
				return Cryo.Dictionary.join(p1, {
					menuPage = parentPage
				})
			end
		end
	elseif p2.type == SetCurrentPage.name then
		return Cryo.Dictionary.join(p1, {
			currentlyOpenBubble = Cryo.None
		})
	end

	return p1
end

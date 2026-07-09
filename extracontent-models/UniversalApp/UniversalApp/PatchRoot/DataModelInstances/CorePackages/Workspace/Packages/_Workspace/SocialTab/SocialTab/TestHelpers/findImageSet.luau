local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local UIBlox = dependencies.UIBlox
local BuilderIcons = dependencies.BuilderIcons
local Migration = BuilderIcons.Migration

local function findImageSet(p1) -- line: 7
	-- upvalues: UIBlox (copy), Migration (copy), BuilderIcons (copy)
	local v8 = UIBlox.App.ImageSet.Images[p1]

	if Migration.uiblox[p1] or Migration.luaApps[p1] then
		local v9 = Migration.uiblox[p1] or Migration.luaApps[p1]

		return {
			Image = nil,
			ImageRectSize = nil,
			ImageRectOffset = nil,
			Text = v9.name,
			FontFace = BuilderIcons.Font[v9.variant]
		}
	end

	return {
		Text = nil,
		FontFace = nil,
		Image = v8.Image,
		ImageRectSize = v8.ImageRectSize,
		ImageRectOffset = v8.ImageRectOffset
	}
end

return findImageSet

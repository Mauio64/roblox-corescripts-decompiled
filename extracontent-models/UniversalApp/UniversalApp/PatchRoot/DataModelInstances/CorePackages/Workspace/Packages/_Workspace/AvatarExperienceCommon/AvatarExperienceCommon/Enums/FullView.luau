local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

return (require(Parent.enumerate)(script.Name, {
	"None",
	"SceneFullView",
	"UIFullView"
}))

local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

require(script.Parent.Parent.Enums.Categories)
require(script.Parent.Parent.Enums.ScreenLayout)
require(script.Parent.Parent.Enums.ItemView)
require(script.Parent.Parent.Stores.createCategoryInventoryStore)
require(script.Parent.Parent.Stores.createSortAndFiltersStore)
require(script.Parent.Parent.Stores.createSlotBasedEditorStore)
require(script.Parent.Parent.Stores.createThumbnailLatencyStore)

local React = require(Parent.React)

require(script.Parent.Parent.Types)

return (React.createContext(nil))

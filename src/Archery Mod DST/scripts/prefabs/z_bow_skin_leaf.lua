local assets = ARCHERYFUNCS.GenerateSkinAssets("z_bow_skin_leaf")

return CreatePrefabSkin("z_bow_skin_leaf",
{
	base_prefab = "bow",
	type = "item",
	assets = assets,
	build_name = "swap_z_bow_skin_leaf",
	rarity = "Distinguished",
	init_fn = function(inst) end,
})
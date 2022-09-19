--- A test menu item that should not be included in production in any way.
--- First use: Figure out how the heck layouts work.


-- Let's see if we can get this code to run in the first place.
function define_test_object()
    api_define_menu_object(
            {
                id = "test_menu",
                name = "Test Menu",
                category = "Tools",
                tooltip = "How do layouts work again?",
                info = {},
                layout = {
                    { 4, 12 },
                    { 5, 15 },
                    { 18, 27, "Input" },
                    { 22, 14, "Output" }
                },
                buttons = { "Close" },
                tools = { "mouse1", "hammer1" },
                placeable = true
            },
            "sprites/item_depot/item_depot_item",
            "",
            {}

    )
end

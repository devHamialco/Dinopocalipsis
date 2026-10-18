## 1. Linked Issue

Closes #1

## 2. PR Type

- [x] Bug fix
- [ ] New feature
- [ ] Documentation only
- [ ] Code refactoring
- [ ] Maintenance/tooling
- [ ] Breaking change

## 3. Summary

- Finalizes the Dinopocalipsis game flow with the main menu, level progression, scoring, and game-over/win loop.
- Adds the final gameplay and audio polish required for a releasable build.
- Keeps controls and UI access consistent across menu, instructions, and level scenes.

## 4. Changes Table

| File | Change |
|------|--------|
| `Scripts/GameManager.gd` | Stores ratings and configures controller mappings for menu and level flow. |
| `Scripts/MusicManager.gd` | Centralizes background and sound effects for menu, win, and level scenes. |
| `Scripts/player.gd` | Adds player movement, health, win/die state, and damage flow. |
| `Scripts/enemigo.gd` | Adds enemy behavior, chase logic, hitbox interaction, and attack cooldowns. |
| `Scripts/nivel.gd` | Updates level progression, final rating calculation, and transitions. |
| `Scripts/menu.gd` | Connects menu buttons and audio feedback. |
| `Scripts/instrucciones.gd` | Adds instruction screen interactions and navigation. |
| `Escenas/*.tscn` | Finishes scene wiring for menus, levels, and UI interactions. |

## 5. Test Plan

- [x] Game scripts load without editor syntax issues.
- [x] Menu and level transitions reviewed manually.
- [x] Player, enemy, and win/lose loop verified in the game flow.

## 6. Contributor Checklist

- [x] Linked an approved issue
- [x] Added exactly one `type:*` label
- [x] Ran validation on the modified game scripts
- [x] Skills tested in at least one agent
- [x] Docs updated if behavior changed
- [x] Conventional commit format
- [x] No `Co-Authored-By` trailers

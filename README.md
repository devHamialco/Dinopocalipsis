# Dinopocalipsis

¡Sobrevive al apocalipsis de meteoritos como un T-Rex en un mundo 3D desértico! Recolecta huevos, esquiva pterodáctilos y demuestra tu puntería para escapar de la extinción.

## Story

Un meteorito se acerca a la Tierra y el caos se desata. Los dinosaurios no se atacan entre sí... hasta ahora. Algo está mal en el desierto: los pterodáctilos atacan sin razón, y solo un T-Rex puede recolectar los huevos suficientes para sobrevivir al cataclismo.

Tres niveles. 25 huevos cada uno. Una misión: **no te conviertas en fósil**.

---

## Quick Start

1. Ejecutar `Dinopocalipsis.exe`
2. Presionar **Play** en el menú principal
3. Seleccionar un **Nivel** (1, 2 o 3)
4. Recolectar los **25 huevos** del nivel
5. Esquivar a los **pterodáctilos**
6. Llegar con la **máxima vida posible** para obtener más estrellas

---

## Controls

| Input | Action |
|-------|--------|
| **W / A / S / D** | Moverse (adelante / izquierda / atrás / derecha) |
| **Space** | Saltar |
| **Mouse** | Mirar alrededor |
| **ESC** | Liberar / capturar el cursor |
| **Joystick izquierdo** | Moverse |
| **Joystick derecho** | Mirar alrededor |
| **Botón A** | Saltar |
| **Botón B** | Liberar / capturar cursor |

---

## Game Mechanics

### Health System

- Comienzas cada nivel con **0 de vida**
- Cada **5 huevos recolectados** recuperas **1 punto de vida** (máximo 5)
- Recibir daño de un pterodáctilo resta **1 punto de vida**
- Si llegas a **0 de vida después de haber tenido al menos 1**, el T-Rex muere
- Si nunca tuviste vida (no recolectaste 5 huevos), no podés morir

### Star Rating

Al completar un nivel, las estrellas que obtienes equivalen a tu **vida actual** (`stars = int(current_health)`):

| Vida al completar | Estrellas |
|-------------------|-----------|
| 5 | ★★★★★ |
| 4 | ★★★★ |
| 3 | ★★★ |
| 2 | ★★ |
| 1 | ★ |
| 0 | ☆ |

**Importante**: para sacar 1 estrella necesitás al menos 5 huevos (que te dan 1 de vida). Si terminás el nivel sin recolectar 5 huevos, tu rating es 0.

Las estrellas se guardan automáticamente entre partidas en `user://ratings.cfg` y se ven como barritas en la pantalla de selección de niveles.

### Eggs (Huevos)

- 25 huevos dispersos por cada nivel
- Caen desde el cielo al inicio del nivel
- Brillan y rotan para ser visibles
- Al recolectar 5, tu vida aumenta en 1

### Enemies

#### Pterodáctilo (Pterablocktyls)
- Enemigo **volador** con IA de persecución
- Tiene alas animadas con shader personalizado (wing_flap.gdshader)
- **Comportamiento inteligente:**
  - Si está **adelante** del T-Rex → persigue la cabeza
  - Si está **detrás** del T-Rex → rodea hacia el costado (flaqueo)
  - Esto simula un "escudo de cola" que lo obliga a flanquearte
- Hace **1 de daño** al contacto
- Tiene un cooldown entre ataques (AttackCooldown timer)
- Se mueve a velocidad 7.2 con gravedad

### Screens & Navigation

| Screen | Description |
|--------|-------------|
| **Menu** | Pantalla principal con botones: Play, Instrucciones, Créditos, Salir |
| **Niveles** | Selección de nivel 1/2/3 con estrellas guardadas |
| **Instrucciones** | Pantalla de ayuda con controles básicos |
| **Créditos** | Información del creador |
| **Game Over** | Overlay al morir con opciones: Menú o Reintentar |
| **Victoria** | Al recolectar los 25 huevos, vuelve a la selección de niveles |

---

## Game Flow

```
Menú Principal
     │
     ▼
Selección de Niveles (elige 1, 2 o 3)
     │
     ▼
Nivel (recolecta 25 huevos, evita pterodáctilos)
     │
     ├── Victoria ──► Guarda estrellas ──► Selección de Niveles
     │
     └── Muerte ──► Game Over (overlay) ──► Menú / Reintentar
```

---

## Soundtrack & Audio

- **Música de menú**: menú.mp3 (loop)
- **Música de nivel**: pista independiente por nivel
- **Efectos**: hover.wav, click.wav, win sound, lose sound
- El **MusicManager** (autoload) maneja la música y evita superposición entre escenas

---

## Technical

| Property | Value |
|----------|-------|
| **Engine** | Godot 4.6.1 |
| **Renderer** | Forward Plus (Direct3D 12 en Windows) |
| **Physics** | Jolt Physics 3D |
| **Scripting** | GDScript |
| **Models** | FBX (T-Rex, Desert), GLB (Pterablocktyls, Huevo) |
| **Resolution** | Escalable con stretch mode (canvas_items + keep aspect) |

### Supported Platforms

- Windows (exportado)
- El proyecto fuente es compatible con cualquier exportación de Godot 4.6+

---

## Project Structure

```
Dinopocalipsis/
├── Escenas/           # Escenas .tscn (niveles, menús, UI)
│   ├── menu.tscn
│   ├── niveles.tscn
│   ├── nivel_1.tscn
│   ├── nivel_2.tscn
│   ├── nivel_3.tscn
│   ├── gameover.tscn
│   ├── instrucciones.tscn
│   ├── creditos.tscn
│   ├── player.tscn
│   ├── enemigo.tscn
│   ├── huevo.tscn
│   ├── escenario.tscn
│   ├── puntos.tscn
│   └── progresbar.tscn
├── Scripts/           # Código GDScript
│   ├── GameManager.gd   # Gestión de estrellas y progreso
│   ├── MusicManager.gd  # Sistema de audio (autoload)
│   ├── menu.gd          # Lógica del menú principal
│   ├── instrucciones.gd # Navegación entre pantallas
│   ├── nivel.gd         # Lógica del nivel (victoria/derrota)
│   ├── player.gd        # Control del T-Rex
│   ├── enemigo.gd       # IA de pterodáctilos
│   ├── huevo.gd         # Huevos recolectables
│   └── stars_container.gd  # Visualización de estrellas
├── Images/            # Texturas e imágenes
├── Music/             # Audio (MP3, WAV)
├── Player/            # Modelo del T-Rex (FBX + armadura)
├── Recursos/          # Modelos, materiales, shaders
│   ├── wing_flap.gdshader  # Shader de aleteo
│   ├── Pterablocktyls.glb  # Modelo del pterodáctilo
│   └── ...
└── addons/            # Plugins (virtual_joystick)
```

---

## Credits

**Desarrollado por:** Hadasa Miriam Alanis Contreras

---

## Building from Source

Requisitos: Godot 4.6.1+

```bash
# Windows export (desde la terminal)
godot --headless --export-release "Windows Desktop" ../Dinopocalipsis.exe
```

El preset de exportación `Windows Desktop` ya está configurado en `export_presets.cfg`.

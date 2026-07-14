# Checklist de revisión manual — Sección 4 del spec 01

Revisión humana de los 3 casos de prueba definidos en
`specs/01-borraodr-emails-compras.md` (sección 4), complementaria a los tests
automatizados de `tests/test_casos_validacion.py`. Generados con
`fecha_referencia = 2026-07-06`.

| Caso | Escenario | Resultado automatizado | Revisión manual |
|---|---|---|---|
| A | Reincidencia grave (proveedor A, cadena_frio, firme-pero-cordial, exigir compensación) | PASS | Aprobado |
| B | Leve / primera vez (proveedor B, documentacion_incorrecta, conciliador, avisar) | PASS | Aprobado |
| C | Mensaje libre integrado ("recordarles el plazo de 48h para responder") | PASS | Aprobado |

Los 3 borradores revisados se consideran representativos de la calidad y el
tono esperados para la PoC. No se identificaron ajustes pendientes.

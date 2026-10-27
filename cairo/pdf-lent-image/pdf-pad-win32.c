/* A Win32 DIB surface painted into a PDF with CAIRO_EXTEND_PAD.
 *
 *   cc pdf-pad-win32.c $(pkg-config --cflags --libs cairo) -o pdf-pad-win32
 *
 * Aborts in cairo_show_page with "!surface->finished" (cairo-surface.c,
 * _cairo_surface_acquire_source_image), called from
 * _cairo_pdf_surface_emit_surface. */
#include <cairo.h>
#include <cairo-pdf.h>
#include <cairo-win32.h>
#include <stdio.h>

int main(void)
{
    cairo_surface_t *dib = cairo_win32_surface_create_with_dib(CAIRO_FORMAT_ARGB32, 64, 64);
    cairo_t *d = cairo_create(dib);
    cairo_set_source_rgb(d, 1, 0, 0);
    cairo_paint(d);
    cairo_destroy(d);

    cairo_surface_t *pdf = cairo_pdf_surface_create("pdf-pad-win32.pdf", 200, 200);
    cairo_t *cr = cairo_create(pdf);
    cairo_pattern_t *pattern = cairo_pattern_create_for_surface(dib);
    cairo_pattern_set_extend(pattern, CAIRO_EXTEND_PAD);
    cairo_set_source(cr, pattern);
    cairo_rectangle(cr, 0, 0, 64, 64);   /* inside the image: no padding needed */
    cairo_fill(cr);
    cairo_pattern_destroy(pattern);
    cairo_show_page(cr);
    cairo_destroy(cr);
    cairo_surface_destroy(pdf);
    cairo_surface_destroy(dib);
    puts("written");
    return 0;
}

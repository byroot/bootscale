#include <ruby.h>

VALUE
bootscale_require(VALUE self, VALUE fname)
{
  return rb_require_safe(fname, rb_safe_level());
}

void
Init__bootscale()
{
  VALUE bootscale_module = rb_const_get(rb_cObject, rb_intern("Bootscale"));
  rb_define_singleton_method(bootscale_module, "require", bootscale_require, 1);
}
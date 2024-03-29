#![feature(no_std, lang_items, const_fn, unique, core_str_ext)]
#![no_std]
extern crate rlibc;
extern crate spin;

#[macro_use]
mod vga_buffer;

#[no_mangle]
pub extern fn rust_main() {
    // ATTENTION: we have a very small stack and no guard page
    vga_buffer::clear_screen();
    println!("Hello World{}", "!");
    loop{}
}

#[lang = "eh_personality"] extern fn eh_personality() {}
#[lang = "panic_fmt"] extern fn panic_fmt() -> ! {loop{}}


TARGET_DIR=./target
LIBNCURSES_CORE = $(TARGET_DIR)/libncurses_core.rlib
LIBNCURSES = $(TARGET_DIR)/libncurses.rlib
RUSTC_FLAGS=-g

all: $(LIBNCURSES) ncurses-intro ncurses-intro-test

clean:
	rm -f $(TARGET_DIR)/*
	rm -f hello{3,4,5}
	rm -f ncurses-intro{,-test}

$(TARGET_DIR)/lib%.rlib: %.rs
	rustc $(RUSTC_FLAGS) --crate-type lib -L $(TARGET_DIR) -o $@ $<

$(LIBNCURSES): ncurses.rs $(LIBNCURSES_CORE)
	rustc $(RUSTC_FLAGS) --crate-type lib -L $(TARGET_DIR) -o $@ $<

hello%: hello%.rs $(LIBNCURSES_CORE)
	rustc $(RUSTC_FLAGS) -L $(TARGET_DIR) --link-args -lncurses -o examples/$@ $<

ncurses-intro: ncurses-intro.rs $(LIBNCURSES)  locale.rs signal_h.rs
	rustc $(RUSTC_FLAGS) -L $(TARGET_DIR) $< -o $@

ncurses-intro-test: ncurses-intro.rs $(LIBNCURSES) locale.rs signal_h.rs
	rustc $(RUSTC_FLAGS) --test -L $(TARGET_DIR) $< -o $@

.PHONY: setup test format check build editorial previews audio review

setup:
	sh tools/setup.sh

test:
	.tools/bin/lune run tests/timeline.test.luau
	.tools/bin/lune run tests/models.test.luau
	.tools/bin/lune run tests/motion.test.luau
	.tools/bin/lune run tests/staging.test.luau
	.tools/bin/lune run tests/films.test.luau

format:
	.tools/bin/stylua src tests tools

check: test
	.tools/bin/stylua --check src tests tools
	git diff --check

build: check
	.tools/bin/lune run tools/build-assets.luau
	.tools/bin/rojo build power.project.json -o build/Power.rbxlx
	.tools/bin/rojo build gate.project.json -o build/Gate.rbxlx
	.tools/bin/lune run tools/build-gallery.luau
	.tools/bin/lune run tests/places.test.luau

editorial:
	.tools/bin/lune run tools/export-editorial.luau

previews:
	python3 -m venv .tools/preview-env
	.tools/preview-env/bin/pip install -r tools/preview-requirements.txt
	.tools/bin/lune run tools/export-previews.luau
	.tools/preview-env/bin/python tools/render-previews.py

audio: editorial
	python3 tools/build-audio.py

review: build editorial previews

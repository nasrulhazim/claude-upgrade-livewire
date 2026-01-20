# Getting Started

Prerequisites and initial steps before upgrading to Livewire 4.

## Step 1: Identify Your Upgrade Type

Before proceeding, determine whether you're upgrading an **application** or a **Laravel package**.

### How to Identify

| Indicator | Application | Package |
|-----------|-------------|---------|
| `composer.json` type | `project` | `library` |
| Has `public/index.php` | Yes | No |
| Has `app/Http/Kernel.php` or `bootstrap/app.php` | Yes | No |
| Published on Packagist | Rarely | Usually |
| Has `extra.laravel.providers` | No | Yes |
| Uses `spatie/laravel-package-tools` | No | Often |

### Quick Detection Script

```bash
#!/bin/bash

echo "=== Upgrade Type Detection ==="

# Check composer.json type
type=$(cat composer.json | grep -o '"type":\s*"[^"]*"' | cut -d'"' -f4)

if [ "$type" = "project" ]; then
    echo "Detected: APPLICATION (type: project)"
    echo "Follow: Application Upgrade Guide"
elif [ "$type" = "library" ]; then
    echo "Detected: PACKAGE (type: library)"
    echo "Follow: Package Upgrade Guide"
elif [ -f "public/index.php" ]; then
    echo "Detected: APPLICATION (has public/index.php)"
    echo "Follow: Application Upgrade Guide"
elif [ -f "src" ] && grep -q "laravel-package-tools\|PackageServiceProvider" composer.json 2>/dev/null; then
    echo "Detected: PACKAGE (uses package-tools)"
    echo "Follow: Package Upgrade Guide"
else
    echo "Unable to auto-detect. Check manually:"
    echo "  - Application: Has routes/, app/Http/, public/"
    echo "  - Package: Has src/, uses ServiceProvider"
fi
```

### Key Differences

| Aspect | Application Upgrade | Package Upgrade |
|--------|---------------------|-----------------|
| **Goal** | Upgrade to Livewire 4 only | Support both Livewire 3 and 4 |
| **Constraint** | `"livewire/livewire": "^4.0"` | `"livewire/livewire": "^3.0 \|\| ^4.0"` |
| **Testing** | Test once with Livewire 4 | Test with both versions |
| **CI Matrix** | Single Livewire version | Multiple Livewire versions |
| **Component Registration** | Standard | Version-aware (optional) |

## Prerequisites

### Version Requirements

Ensure your environment meets these requirements:

| Requirement | Version |
|-------------|---------|
| PHP | 8.1+ |
| Laravel | 10.x, 11.x, or 12.x |
| Livewire (current) | 3.x |

### Check Current Version

```bash
composer show livewire/livewire
```

## Pre-Upgrade Checklist

### 1. Create a Backup Branch

```bash
git checkout -b livewire-4-upgrade
```

### 2. Ensure Tests Pass

```bash
# Run your test suite
composer test

# If using PHPUnit directly
vendor/bin/phpunit

# If using Pest
vendor/bin/pest
```

### 3. Check Dependencies

List packages that depend on Livewire:

```bash
composer depends livewire/livewire
```

Review each package for Livewire 4 compatibility.

### 4. Document Current State

Save your current test output for comparison:

```bash
composer test > pre-upgrade-test-results.txt 2>&1
```

## Upgrade Paths

### Path A: Simple Application

If your application:

- Uses standard Livewire patterns
- Has no custom JavaScript integration
- Has good test coverage

**Estimated time**: 15-30 minutes

Follow: [Application Upgrade](02-application-upgrade.md)

### Path B: Complex Application

If your application:

- Has custom Livewire extensions
- Uses JavaScript hooks
- Has many Livewire components (50+)

**Estimated time**: 1-4 hours

Follow: [Application Upgrade](02-application-upgrade.md) with extra testing

### Path C: Package Upgrade

If you maintain a Laravel package that:

- Depends on Livewire
- Needs to support both Livewire 3 and 4

**Estimated time**: 30 minutes - 1 hour

Follow: [Package Upgrade](03-package-upgrade.md)

## Quick Assessment

Run this script to assess your codebase:

```bash
#!/bin/bash

echo "=== Livewire Upgrade Assessment ==="
echo ""

# Detect upgrade type
echo "Upgrade Type Detection:"
type=$(cat composer.json 2>/dev/null | grep -o '"type":\s*"[^"]*"' | cut -d'"' -f4)

if [ "$type" = "project" ]; then
    echo "  Type: APPLICATION"
    echo "  Guide: Application Upgrade (02-application-upgrade.md)"
    src_dir="app"
elif [ "$type" = "library" ]; then
    echo "  Type: PACKAGE"
    echo "  Guide: Package Upgrade (03-package-upgrade.md)"
    src_dir="src"
elif [ -f "public/index.php" ]; then
    echo "  Type: APPLICATION (detected)"
    src_dir="app"
else
    echo "  Type: PACKAGE (assumed)"
    src_dir="src"
fi

echo ""

# Count components
echo "Livewire Components:"
find $src_dir -name "*.php" -exec grep -l "extends Component" {} \; 2>/dev/null | wc -l | xargs echo "  PHP files:"
find resources/views/livewire -name "*.blade.php" 2>/dev/null | wc -l | xargs echo "  Blade views:"

echo ""
echo "Deprecated Patterns Found:"

# Check for deprecated emit
emit_count=$(grep -r "->emit(" $src_dir/ --include="*.php" 2>/dev/null | wc -l)
echo "  emit(): $emit_count"

emitTo_count=$(grep -r "->emitTo(" $src_dir/ --include="*.php" 2>/dev/null | wc -l)
echo "  emitTo(): $emitTo_count"

emitUp_count=$(grep -r "->emitUp(" $src_dir/ --include="*.php" 2>/dev/null | wc -l)
echo "  emitUp(): $emitUp_count"

listeners_count=$(grep -r "protected \$listeners" $src_dir/ --include="*.php" 2>/dev/null | wc -l)
echo "  \$listeners property: $listeners_count"

echo ""
total=$((emit_count + emitTo_count + emitUp_count + listeners_count))
if [ $total -eq 0 ]; then
    echo "Assessment: LOW RISK - No deprecated patterns found"
else
    echo "Assessment: MEDIUM RISK - Found $total deprecated patterns"
    echo "These patterns still work but should be updated."
fi
```

Save as `assess-livewire-upgrade.sh` and run:

```bash
chmod +x assess-livewire-upgrade.sh
./assess-livewire-upgrade.sh
```

## Next Steps

Based on your scenario:

- **Application**: [Application Upgrade](02-application-upgrade.md)
- **Package**: [Package Upgrade](03-package-upgrade.md)
- **Issues**: [Troubleshooting](04-troubleshooting.md)

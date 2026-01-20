# Getting Started

Prerequisites and initial steps before upgrading to Livewire 4.

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

# Count components
echo "Livewire Components:"
find app -name "*.php" -exec grep -l "extends Component" {} \; 2>/dev/null | wc -l | xargs echo "  PHP files:"
find resources/views/livewire -name "*.blade.php" 2>/dev/null | wc -l | xargs echo "  Blade views:"

echo ""
echo "Deprecated Patterns Found:"

# Check for deprecated emit
emit_count=$(grep -r "->emit(" app/ --include="*.php" 2>/dev/null | wc -l)
echo "  emit(): $emit_count"

emitTo_count=$(grep -r "->emitTo(" app/ --include="*.php" 2>/dev/null | wc -l)
echo "  emitTo(): $emitTo_count"

emitUp_count=$(grep -r "->emitUp(" app/ --include="*.php" 2>/dev/null | wc -l)
echo "  emitUp(): $emitUp_count"

listeners_count=$(grep -r "protected \$listeners" app/ --include="*.php" 2>/dev/null | wc -l)
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

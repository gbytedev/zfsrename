# zfsrename
Batch-rename for ZFS snapshots. Renames ZFS snapshots based on a wildcard string.

## Usage
### Scenario
pool/dataset1@old1
pool/dataset1@old2
pool/dataset2@old1
pool2/dataset1@old1

### Rename all
`zfsrename.sh old new`

#### Result
pool/dataset1@new1
pool/dataset1@new2
pool/dataset@new1
pool2/dataset1@new1

### Limit renaming to a single pool
`zfsrename.sh -D pool1/ old new`

#### Result
pool/dataset1@new1
pool/dataset1@new2
pool/dataset2@new1
pool2/dataset1@old1

### Limit renaming to a single dataset
`zfsrename.sh -D pool/dataset1@ old new`

#### Result
pool/dataset1@new1
pool/dataset1@new2
pool/dataset2@old1
pool2/dataset1@old1

### Dry run
Use --dry-run|-d to see the result without making the actual changes.

## Credit
Created and maintained by Pawel Ginalski (https://gbyte.dev).

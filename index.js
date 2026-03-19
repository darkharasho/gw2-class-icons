'use strict';

const fs = require('node:fs');
const path = require('node:path');

const PACKAGE_ROOT = __dirname;
const DEFAULT_SIZE = '40px';

const ICON_SETS = Object.freeze({
  '20px': { folder: path.join(PACKAGE_ROOT, 'wiki', '20px'), extension: '.png' },
  '40px': { folder: path.join(PACKAGE_ROOT, 'wiki', '40px'), extension: '.png' },
  '150px': { folder: path.join(PACKAGE_ROOT, 'wiki', '150px'), extension: '.png' },
  'high-res': { folder: path.join(PACKAGE_ROOT, 'wiki', 'high-res'), extension: '.png' },
  optimized: { folder: path.join(PACKAGE_ROOT, 'wiki', 'optimized'), extension: '.png' },
  raw: { folder: path.join(PACKAGE_ROOT, 'wiki', 'raw'), extension: '.png' },
  svg: { folder: path.join(PACKAGE_ROOT, 'wiki', 'svg'), extension: '.svg' }
});

const iconSizes = Object.freeze(Object.keys(ICON_SETS));

const toPosixPath = (input) => input.split(path.sep).join('/');

const listIconNames = (size) => {
  const { folder, extension } = ICON_SETS[size];
  if (!fs.existsSync(folder)) {
    return [];
  }

  return fs
    .readdirSync(folder, { withFileTypes: true })
    .filter((entry) => entry.isFile() && entry.name.toLowerCase().endsWith(extension))
    .map((entry) => entry.name.slice(0, -extension.length));
};

const iconNames = Object.freeze(
  Array.from(new Set(iconSizes.flatMap((size) => listIconNames(size)))).sort((a, b) =>
    a.localeCompare(b)
  )
);

const iconNameByLowercase = new Map(iconNames.map((name) => [name.toLowerCase(), name]));

const icons = Object.freeze(
  iconNames.reduce((result, name) => {
    const pathsBySize = {};
    for (const size of iconSizes) {
      const { folder, extension } = ICON_SETS[size];
      const absolutePath = path.join(folder, `${name}${extension}`);
      if (fs.existsSync(absolutePath)) {
        pathsBySize[size] = toPosixPath(path.relative(PACKAGE_ROOT, absolutePath));
      }
    }

    result[name] = Object.freeze(pathsBySize);
    return result;
  }, {})
);

const normalizeSize = (size = DEFAULT_SIZE) => {
  if (typeof size !== 'string' || !ICON_SETS[size]) {
    throw new RangeError(
      `Invalid icon size "${size}". Expected one of: ${iconSizes.join(', ')}`
    );
  }
  return size;
};

const normalizeName = (name) => {
  if (typeof name !== 'string' || name.trim().length === 0) {
    return null;
  }
  return icons[name] ? name : iconNameByLowercase.get(name.toLowerCase()) || null;
};

const hasIcon = (name, size = DEFAULT_SIZE) => {
  const normalizedName = normalizeName(name);
  if (!normalizedName) {
    return false;
  }

  const normalizedSize = normalizeSize(size);
  return Boolean(icons[normalizedName][normalizedSize]);
};

const getIconPath = (name, size = DEFAULT_SIZE, options = {}) => {
  const normalizedName = normalizeName(name);
  if (!normalizedName) {
    throw new Error(`Unknown icon "${name}".`);
  }

  const normalizedSize = normalizeSize(size);
  const relativePath = icons[normalizedName][normalizedSize];
  if (!relativePath) {
    throw new Error(
      `Icon "${normalizedName}" is not available in size "${normalizedSize}".`
    );
  }

  return options.absolute
    ? path.join(PACKAGE_ROOT, relativePath)
    : relativePath;
};

module.exports = {
  iconNames,
  iconSizes,
  icons,
  hasIcon,
  getIconPath
};

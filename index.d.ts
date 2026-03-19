export type IconSize =
  | '20px'
  | '40px'
  | '150px'
  | 'high-res'
  | 'optimized'
  | 'raw'
  | 'svg';

export interface IconPathOptions {
  absolute?: boolean;
}

export declare const iconSizes: readonly IconSize[];
export declare const iconNames: readonly string[];
export declare const icons: Readonly<
  Record<string, Readonly<Partial<Record<IconSize, string>>>>
>;

export declare function hasIcon(name: string, size?: IconSize): boolean;
export declare function getIconPath(
  name: string,
  size?: IconSize,
  options?: IconPathOptions
): string;

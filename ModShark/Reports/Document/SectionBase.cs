﻿namespace ModShark.Reports.Document;

public abstract class SectionBase<TBuilder> : SegmentBase<TBuilder>
    where TBuilder : BuilderBase<TBuilder>
{
    public ListBuilder<TBuilder> BeginList() =>
        new(
            Format.ListStart(),
            this,
            Format.ListEnd()
        );

    public TBuilder AppendLineBreak() =>
        Append(Format.LineBreak());
}
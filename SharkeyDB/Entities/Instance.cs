﻿using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.CodeAnalysis;

namespace SharkeyDB.Entities;

/// <summary>
/// Sharkey instance
/// </summary>
[Table("instance")]
public class Instance : IEntity<string>
{
    /// <summary>
    /// Unique ID of the instance
    /// </summary>
    [Column("id"), MaxLength(32), Key]
    public required string Id { get; set; }
    
    /// <summary>
    /// Hostname of the instance
    /// </summary>
    [Column("host"), MaxLength(512)]
    public required string Host { get; set; }
    
    /// <summary>
    /// Human-readable description of the instance
    /// </summary>
    [Column("description"), MaxLength(4096)]
    public string? Description { get; set; }

    [MemberNotNullWhen(true, nameof(Description))]
    public bool HasDescription => Description != null;
    
    /// <summary>
    /// Status and/or reason of the instance suspension.
    /// This is actually an enum, but we are *not* dealing with that.
    /// </summary>
    [Column("suspensionState"), MaxLength(256)]
    public required string SuspensionState { get; set; }
    
    public MSQueuedInstance? QueuedInstance { get; set; }
    public MSFlaggedInstance? FlaggedInstance { get; set; }
    
    public ICollection<User> Users { get; set; } = new List<User>();
    public ICollection<Note> Notes { get; set; } = new List<Note>();
}